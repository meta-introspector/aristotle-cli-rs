import RequestProject.Solfunmeme.Onchain.Base58
import RequestProject.Solfunmeme.Onchain.Dataset

/-!
The Solana JSON-RPC client.

The ingestion path is the one that works on *every* public endpoint, including
the free `https://api.mainnet-beta.solana.com`:

* `getTokenSupply` (or `getAccountInfo` on the mint) — decimals and total supply;
* `getTokenLargestAccounts` — the twenty largest **token accounts** of the mint;
* `getMultipleAccounts` — (optional) `jsonParsed` decode of those token accounts,
  which yields the *wallet* owning each of them, so that several accounts
  belonging to one wallet can be merged;
* `getSignaturesForAddress` — the recent transaction activity of the mint.

Transport is a `curl` subprocess, so the program needs nothing beyond a standard
Unix box.  Every response is read from, and written back to, the corpus described
in `RequestProject.Onchain.Dataset`, so a run is reproducible, stays inside the rate
limit of the public endpoint, and can be replayed with `--offline` against a
local clone of the dataset with no network at all.
-/

namespace Solana.Rpc

open Lean (Json)
open Solana.Holders
open Solana.Dataset

/-- Where to talk, how long to wait, and which corpus to use. -/
structure Config where
  /-- JSON-RPC endpoint URL. -/
  endpoint : String := "https://api.mainnet-beta.solana.com"
  /-- Directory of captured responses; `none` disables both reading and writing. -/
  dataset : Option String := some "rpc_cache"
  /-- Never touch the network; fail instead if the corpus lacks a response. -/
  offline : Bool := false
  /-- `curl --max-time` in seconds. -/
  timeout : Nat := 30
  /-- How many times to retry a failing request. -/
  retries : Nat := 3
  deriving Repr, Inhabited

/-! ### Request construction and transport -/

/-- A JSON-RPC 2.0 request envelope. -/
def envelope (method : String) (params : List Json) : Json :=
  Json.mkObj
    [ ("jsonrpc", Json.str "2.0")
    , ("id", Json.num 1)
    , ("method", Json.str method)
    , ("params", Json.arr params.toArray) ]

/-- Run one `curl` POST, returning the response body. -/
def curlPost (cfg : Config) (body : String) : IO String := do
  let out ← IO.Process.output
    { cmd := "curl"
      args := #[ "-s", "-S", "--fail-with-body"
               , "--max-time", toString cfg.timeout
               , "-X", "POST"
               , "-H", "Content-Type: application/json"
               , "-d", body
               , cfg.endpoint ] }
  if out.exitCode == 0 then
    return out.stdout
  else
    throw <| IO.userError s!"curl failed (exit {out.exitCode}): {out.stderr}\n{out.stdout}"

/-- `curlPost` with retries and linear backoff. -/
partial def curlPostRetry (cfg : Config) (body : String) : IO String :=
  let rec go : Nat → IO String
    | 0 => curlPost cfg body
    | n + 1 => try curlPost cfg body
               catch _ => do
                 IO.sleep (UInt32.ofNat (500 * (cfg.retries - n)))
                 go n
  go cfg.retries

/-- Perform a JSON-RPC call, going through the corpus: a stored capture is used
when present, otherwise the endpoint is queried and the response is captured.
The `result` field is returned; a JSON-RPC `error` is raised as an `IO` error. -/
def call (cfg : Config) (k : Key) (params : List Json) : IO Json := do
  let cached ← match cfg.dataset with
    | none => pure none
    | some dir => Dataset.read? (System.FilePath.mk dir) k
  let raw ← match cached with
    | some s => pure s
    | none => do
        if cfg.offline then
          throw <| IO.userError
            s!"offline: no capture of {filePrefix k}* in the dataset"
        let s ← curlPostRetry cfg (envelope k.method params).compress
        match cfg.dataset with
        | none => pure ()
        | some dir => discard <| Dataset.write (System.FilePath.mk dir) k s
        pure s
  match Dataset.resultOf raw with
  | .ok j => return j
  | .error e => throw <| IO.userError s!"{k.method}: {e}"

/-- Lift a pure parser into `IO`. -/
def orThrow (what : String) : Except String α → IO α
  | .ok a => pure a
  | .error e => throw <| IO.userError s!"{what}: {e}"

/-! ### The individual calls -/

/-- Decimals and raw supply of a mint, preferring `getTokenSupply` and falling
back to `getAccountInfo` on the mint account. -/
def getSupply (cfg : Config) (mint : String) : IO (Nat × Nat) := do
  try
    orThrow "getTokenSupply" (parseTokenSupply (← call cfg (tokenSupply mint) [Json.str mint]))
  catch _ =>
    let opts := Json.mkObj [("encoding", Json.str "jsonParsed")]
    let r ← call cfg (accountInfo mint) [Json.str mint, opts]
    orThrow "getAccountInfo" (parseMintAccountInfo r)

/-- The (at most twenty) largest token accounts of a mint. -/
def getTokenLargestAccounts (cfg : Config) (mint : String) :
    IO (List TokenAccountBalance) := do
  let r ← call cfg (tokenLargestAccounts mint) [Json.str mint]
  orThrow "getTokenLargestAccounts" (parseLargestAccounts r)

/-- Attach owners to token accounts positionally; a missing owner leaves the
account's own address in place. -/
def attachOwners (accs : List TokenAccountBalance) (owners : List (Option String)) :
    List TokenAccountBalance :=
  accs.zipWith (fun a o => { a with owner := o }) (owners ++ List.replicate accs.length none)

/-- The holder attributed to a token account: its wallet when known, else the
token account address itself. -/
def toHolder (a : TokenAccountBalance) : Holder :=
  ⟨a.owner.getD a.address, a.amount⟩

/-- Resolve the wallet owning each token account. -/
def resolveOwners (cfg : Config) (accs : List TokenAccountBalance) :
    IO (List TokenAccountBalance) := do
  if accs.isEmpty then return accs
  let addresses := accs.map TokenAccountBalance.address
  let params := [ Json.arr ((addresses.map Json.str).toArray)
                , Json.mkObj [("encoding", Json.str "jsonParsed")] ]
  let r ← call cfg (multipleAccounts addresses) params
  return attachOwners accs (← orThrow "getMultipleAccounts" (parseOwners r))

/-- Recent transaction signatures touching an address. -/
def getSignatures (cfg : Config) (address : String) : IO (List SignatureRecord) := do
  let r ← call cfg (signaturesForAddress address) [Json.str address]
  orThrow "getSignaturesForAddress" (parseSignatures r)

/-! ### The high-level ingestion -/

/-- One full ingestion run: supply, largest accounts, optional owner resolution,
aggregation by wallet and sorting. -/
def ingest (cfg : Config) (mint : String) (resolve : Bool := true) : IO Snapshot := do
  unless Solana.Base58.isValidPubkey mint do
    throw <| IO.userError s!"not a base-58 32-byte public key: {mint}"
  let (decimals, supply) ← getSupply cfg mint
  let accs ← getTokenLargestAccounts cfg mint
  let accs ← if resolve then resolveOwners cfg accs else pure accs
  return { mint, decimals, supply, holders := sortedDesc (aggregate (accs.map toHolder)) }

/-- Rebuild a snapshot from saved JSON-RPC *results*, with no network access.
`supplyResult` may be either a `getTokenSupply` or a `getAccountInfo` result. -/
def snapshotOfResults (mint : String) (supplyResult largestResult : Json)
    (ownersResult : Option Json := none) : Except String Snapshot := do
  let (decimals, supply) ←
    match parseTokenSupply supplyResult with
    | .ok x => pure x
    | .error _ => parseMintAccountInfo supplyResult
  let accs ← parseLargestAccounts largestResult
  let accs ← match ownersResult with
    | none => pure accs
    | some o => do let os ← parseOwners o; pure (attachOwners accs os)
  return { mint, decimals, supply, holders := sortedDesc (aggregate (accs.map toHolder)) }

end Solana.Rpc
