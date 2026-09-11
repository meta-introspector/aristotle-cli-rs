import Lean.Data.Json
import RequestProject.Solfunmeme.Onchain.Decimal
import RequestProject.Solfunmeme.Onchain.Holders

/-!
The on-disk corpus of raw JSON-RPC responses.

Files are named

    method_<method>_<paramKey>_<paramValue>_<hash>.json

and contain the *whole* JSON-RPC response (`{"jsonrpc":…,"id":…,"result":…}`),
exactly as the validator returned it.  Two consequences we rely on:

* a directory in this format is simultaneously a response **cache** and a
  **dataset**, so a local clone can be replayed offline and freshly fetched
  responses can be written back into it;
* the trailing `<hash>` is opaque — it identifies a particular capture, not the
  request — so lookup matches on the `method_<method>_<paramKey>_<paramValue>_`
  prefix and takes the most recent capture, while writing uses a hash we compute
  ourselves.

This module also contains the parsers for the response shapes the corpus holds:
`getAccountInfo` on a mint, `getTokenSupply`, `getTokenLargestAccounts`,
`getMultipleAccounts` and `getSignaturesForAddress`.
-/

namespace Solana.Dataset

open Lean (Json)
open Solana.Holders

/-- Identifies one request: a method plus its distinguishing parameter. -/
structure Key where
  /-- JSON-RPC method name, e.g. `getTokenSupply`. -/
  method : String
  /-- Name of the distinguishing parameter, e.g. `address` or `signature`. -/
  paramKey : String
  /-- Its value, e.g. a base-58 mint address. -/
  paramValue : String
  deriving Repr, Inhabited, DecidableEq

/-- The filename prefix shared by every capture of a request. -/
def filePrefix (k : Key) : String :=
  s!"method_{k.method}_{k.paramKey}_{k.paramValue}_"

/-- The filename for a capture with the given discriminator. -/
def fileName (k : Key) (discriminator : UInt64) : String :=
  filePrefix k ++ toString discriminator ++ ".json"

/-- Is `name` a capture of the request `k`? -/
def isCaptureOf (k : Key) (name : String) : Bool :=
  name.startsWith (filePrefix k) && name.endsWith ".json"

/-! ### Well-known keys -/

/-- `getAccountInfo` on an address (for a mint: decimals and supply). -/
def accountInfo (address : String) : Key := ⟨"getAccountInfo", "address", address⟩

/-- `getTokenSupply` on a mint. -/
def tokenSupply (mint : String) : Key := ⟨"getTokenSupply", "address", mint⟩

/-- `getTokenLargestAccounts` on a mint. -/
def tokenLargestAccounts (mint : String) : Key := ⟨"getTokenLargestAccounts", "address", mint⟩

/-- `getSignaturesForAddress` on an address. -/
def signaturesForAddress (address : String) : Key :=
  ⟨"getSignaturesForAddress", "address", address⟩

/-- `getMultipleAccounts` on a list of addresses; the addresses themselves are
too long for a filename, so they are condensed into a digest. -/
def multipleAccounts (addresses : List String) : Key :=
  ⟨"getMultipleAccounts", "addresses", toString (hash (String.intercalate "," addresses)).toNat⟩

/-! ### Reading and writing the corpus -/

/-- All captures of `k` present in `dir`, newest name last. -/
def captures (dir : System.FilePath) (k : Key) : IO (List System.FilePath) := do
  if !(← dir.pathExists) then return []
  let entries ← dir.readDir
  let names := entries.toList.filterMap fun e =>
    if isCaptureOf k e.fileName then some e.fileName else none
  return (names.mergeSort (· ≤ ·)).map (fun n : String => dir / System.FilePath.mk n)

/-- Read the most recent capture of `k`, if the corpus has one. -/
def read? (dir : System.FilePath) (k : Key) : IO (Option String) := do
  match (← captures dir k).reverse.head? with
  | none => return none
  | some p => return some (← IO.FS.readFile p)

/-- Write a response into the corpus under the naming convention, returning the
path written.  The discriminator is derived from the response body, so
re-capturing an identical response overwrites rather than accumulates. -/
def write (dir : System.FilePath) (k : Key) (body : String) : IO System.FilePath := do
  IO.FS.createDirAll dir
  let path := dir / fileName k (hash body)
  IO.FS.writeFile path body
  return path

/-- Parse a corpus entry and project out its `result` (accepting a bare result
too, so hand-made fixtures work). -/
def resultOf (raw : String) : Except String Json := do
  let j ← Json.parse raw
  match j.getObjVal? "error" with
  | .ok e => .error s!"RPC error in capture: {e.compress}"
  | .error _ => .ok ((j.getObjVal? "result").toOption.getD j)

/-- Read the `result` of the most recent capture of `k`. -/
def readResult? (dir : System.FilePath) (k : Key) : IO (Option Json) := do
  match ← read? dir k with
  | none => return none
  | some raw =>
      match resultOf raw with
      | .ok j => return some j
      | .error e => throw <| IO.userError s!"{filePrefix k}*: {e}"

/-! ### Response parsers -/

/-- Read a decimal-string field exactly into a `Nat`. -/
def amountField (j : Json) (field : String) : Except String Nat := do
  let s ← j.getObjVal? field >>= Json.getStr?
  match Solana.Decimal.parse s with
  | some n => .ok n
  | none => .error s!"field {field}: not a decimal amount: {s}"

/-- Decimals and raw supply from a `getTokenSupply` result. -/
def parseTokenSupply (result : Json) : Except String (Nat × Nat) := do
  let v ← result.getObjVal? "value"
  let decimals ← v.getObjVal? "decimals" >>= Json.getNat?
  let amount ← amountField v "amount"
  return (decimals, amount)

/-- Decimals and raw supply from a `jsonParsed` `getAccountInfo` on the **mint**
account.  This is the shape the corpus stores for the mint itself. -/
def parseMintAccountInfo (result : Json) : Except String (Nat × Nat) := do
  let info ← result.getObjVal? "value" >>= (·.getObjVal? "data")
              >>= (·.getObjVal? "parsed") >>= (·.getObjVal? "info")
  let decimals ← info.getObjVal? "decimals" >>= Json.getNat?
  let supply ← amountField info "supply"
  return (decimals, supply)

/-- Token accounts from a `getTokenLargestAccounts` result. -/
def parseLargestAccounts (result : Json) : Except String (List TokenAccountBalance) := do
  let v ← result.getObjVal? "value" >>= Json.getArr?
  v.toList.mapM fun e => do
    let address ← e.getObjVal? "address" >>= Json.getStr?
    let amount ← amountField e "amount"
    return ({ address, owner := none, amount } : TokenAccountBalance)

/-- Wallet owners from a `jsonParsed` `getMultipleAccounts` result, positionally
aligned with the requested addresses. -/
def parseOwners (result : Json) : Except String (List (Option String)) := do
  let v ← result.getObjVal? "value" >>= Json.getArr?
  return v.toList.map fun e =>
    (e.getObjVal? "data" >>= (·.getObjVal? "parsed") >>= (·.getObjVal? "info")
       >>= (·.getObjVal? "owner") >>= Json.getStr?).toOption

/-- One entry of a `getSignaturesForAddress` result. -/
structure SignatureRecord where
  /-- Transaction signature (base 58). -/
  signature : String
  /-- Slot the transaction landed in. -/
  slot : Nat
  /-- Unix timestamp of the block, when the validator reported one. -/
  blockTime : Option Nat
  /-- Attached SPL memo, if any. -/
  memo : Option String
  /-- `true` when the transaction landed with an error. -/
  failed : Bool
  deriving Repr, Inhabited

/-- Parse a `getSignaturesForAddress` result. -/
def parseSignatures (result : Json) : Except String (List SignatureRecord) := do
  let arr ← Json.getArr? result
  arr.toList.mapM fun e => do
    let signature ← e.getObjVal? "signature" >>= Json.getStr?
    let slot ← e.getObjVal? "slot" >>= Json.getNat?
    let blockTime := (e.getObjVal? "blockTime" >>= Json.getNat?).toOption
    let memo := (e.getObjVal? "memo" >>= Json.getStr?).toOption
    let failed := match e.getObjVal? "err" with
      | .ok Json.null => false
      | .ok _ => true
      | .error _ => false
    return { signature, slot, blockTime, memo, failed }

/-! ### Derived statistics -/

/-- Summary of a page of signatures: how many landed, how many failed, and the
slot and time span they cover. -/
structure ActivitySummary where
  /-- Total number of signatures in the page. -/
  total : Nat
  /-- How many of them carry an `err`. -/
  failed : Nat
  /-- How many carry an SPL memo. -/
  memoed : Nat
  /-- Lowest and highest slot seen. -/
  slotRange : Option (Nat × Nat)
  /-- Earliest and latest block time seen. -/
  timeRange : Option (Nat × Nat)
  deriving Repr, Inhabited

/-- Least and greatest element of a list of naturals. -/
def rangeOf (ns : List Nat) : Option (Nat × Nat) :=
  match ns with
  | [] => none
  | n :: t => some (t.foldl min n, t.foldl max n)

/-- Summarise a page of signatures. -/
def summarize (rs : List SignatureRecord) : ActivitySummary :=
  { total := rs.length
    failed := (rs.filter SignatureRecord.failed).length
    memoed := (rs.filter (fun r => r.memo.isSome)).length
    slotRange := rangeOf (rs.map SignatureRecord.slot)
    timeRange := rangeOf (rs.filterMap SignatureRecord.blockTime) }

end Solana.Dataset
