/-!
The holder model and the concentration metrics computed from it.

Everything here is exact: amounts are natural numbers of raw base units (no
floating point anywhere), and every share is a `Rat`.  Formatting to a decimal
string happens only at the very edge, in `RequestProject.Onchain.Cli`.

Mathlib-free by design; the theorems live in `RequestProject.Onchain.Proofs.Holders`.
-/

namespace Solana.Holders

/-- One SPL token account as returned by `getTokenLargestAccounts`, optionally
enriched with its owner (wallet) address by a follow-up `getMultipleAccounts`. -/
structure TokenAccountBalance where
  /-- The token account's own address. -/
  address : String
  /-- The wallet that owns the token account, when it has been resolved. -/
  owner : Option String := none
  /-- Balance in raw base units. -/
  amount : Nat
  deriving Repr, Inhabited, DecidableEq

/-- A holder: an address together with the balance attributed to it. -/
structure Holder where
  /-- Wallet or token-account address. -/
  address : String
  /-- Balance in raw base units. -/
  amount : Nat
  deriving Repr, Inhabited, DecidableEq

/-- Everything one ingestion run collects about a mint. -/
structure Snapshot where
  /-- The mint (token) address. -/
  mint : String
  /-- Number of decimal places of the token. -/
  decimals : Nat
  /-- Total supply in raw base units, from `getTokenSupply`. -/
  supply : Nat
  /-- The holders that were ingested (in general a prefix of the true holder list). -/
  holders : List Holder
  deriving Repr, Inhabited

/-- Total of a list of amounts. -/
def totalAmount (hs : List Holder) : Nat :=
  (hs.map Holder.amount).sum

/-! ### Aggregation by address -/

/-- Add `amount` to the entry for `addr`, appending a new entry if absent. -/
def addTo (addr : String) (amount : Nat) : List Holder → List Holder
  | [] => [⟨addr, amount⟩]
  | h :: t => if h.address = addr then ⟨h.address, h.amount + amount⟩ :: t
              else h :: addTo addr amount t

/-- Merge holders that share an address, summing their balances.  Needed because
several token accounts can belong to the same wallet. -/
def aggregate (hs : List Holder) : List Holder :=
  hs.foldl (fun acc h => addTo h.address h.amount acc) []

/-! ### Ordering -/

/-- Holders sorted by balance, largest first. -/
def sortedDesc (hs : List Holder) : List Holder :=
  hs.mergeSort (fun a b => b.amount ≤ a.amount)

/-! ### Concentration metrics -/

/-- `share part total` is `part / total`, and `0` for an empty supply. -/
def share (part total : Nat) : Rat :=
  if total = 0 then 0 else (part : Rat) / (total : Rat)

/-- Combined balance of the `k` largest holders. -/
def topKAmount (k : Nat) (hs : List Holder) : Nat :=
  totalAmount ((sortedDesc hs).take k)

/-- Fraction of `total` held by the `k` largest holders. -/
def topKShare (k : Nat) (hs : List Holder) (total : Nat) : Rat :=
  share (topKAmount k hs) total

/-- Herfindahl–Hirschman index: the sum of squared shares.  `1` means a single
holder owns everything; `1/n` is a perfectly even split between `n` holders. -/
def herfindahl (hs : List Holder) (total : Nat) : Rat :=
  (hs.map (fun h => share h.amount total * share h.amount total)).sum

/-- The smallest `k ≤ hs.length` for which the top `k` holders control more than
half of `total`, if such a `k` exists (the Nakamoto coefficient). -/
def nakamoto (hs : List Holder) (total : Nat) : Option Nat :=
  (List.range (hs.length + 1)).find? (fun k => decide (1 < 2 * topKShare k hs total))

end Solana.Holders
