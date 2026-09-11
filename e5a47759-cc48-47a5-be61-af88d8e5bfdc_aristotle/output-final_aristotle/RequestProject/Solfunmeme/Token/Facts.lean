/-
# The book, against what the chain actually says

`RequestProject/Token/Supply.lean` proves things about *any* book.  This file
points that model at the one book the holders care about, using the mint's own
JSON-RPC capture as transcribed in `RequestProject/Onchain/Data/Captures.lean`
(regenerated and checked by `python3 scripts/onchain_facts.py --check`).

What is proved:

* `supply_no_longer_growable` — the mint has no mint authority and no freeze
  authority, so no further token can be issued and no account can be frozen.
  This is the on-chain half of the "fixed supply" answer, and it is a fact about
  the capture, not a promise;
* `captured_supply_le_nominal` — the captured supply is at or below the nominal
  one billion tokens;
* `gap_to_nominal` — it is below it by 93 969 786 882 base units, i.e.
  93 969.786882 tokens, which is what has left the supply since issuance;
* `gap_is_under_a_hundredth_of_a_percent` — that is less than one part in ten
  thousand of the nominal supply, so the deflation to date is real but tiny;
* `chainBook_issued`, `chain_supply_capped` — reading the capture as a book of
  the kind `Supply.lean` reasons about, the tokens ever issued are exactly the
  nominal billion, and *no* sequence of locks, unlocks, burns or burn-to-mint
  rituals can change that number.

Two honesty notes.  The capture is a reading taken at one slot, not a live
query; and "nominal one billion" is the figure the project quotes, entered here
as `nominalSupplyRaw` — the theorem `captured_supply_le_nominal` compares the
capture to it rather than deriving it from the chain.
-/
import RequestProject.Solfunmeme.Onchain.CaptureFacts
import RequestProject.Solfunmeme.Token.Supply

namespace SFM.Token

open Solana.Captures

/-! ## The nominal supply -/

/-- One billion tokens at the mint's six decimals, in base units. -/
def nominalSupplyRaw : ℕ := 1000000000 * 1000000

/-- **Nothing can be minted any more.**  The mint has neither a mint authority
nor a freeze authority, by its own capture. -/
theorem supply_no_longer_growable :
    realMintAuthority = none ∧ realFreezeAuthority = none :=
  Solana.CaptureFacts.mint_authorities_are_null

/-- The captured supply does not exceed the nominal billion. -/
theorem captured_supply_le_nominal : realSupply ≤ nominalSupplyRaw := by
  norm_num [nominalSupplyRaw, realSupply]

/-- What has left the supply since issuance: 93 969.786882 tokens. -/
theorem gap_to_nominal : nominalSupplyRaw - realSupply = 93969786882 := by
  norm_num [nominalSupplyRaw, realSupply]

/-- That gap is less than one part in ten thousand of the nominal supply. -/
theorem gap_is_under_a_hundredth_of_a_percent :
    10000 * (nominalSupplyRaw - realSupply) < nominalSupplyRaw := by
  norm_num [nominalSupplyRaw, realSupply]

/-! ## The capture, read as a book -/

/-- The captured state as a book: everything captured is circulating, and the
difference from the nominal supply is treated as already burned. -/
def chainBook : Book := ⟨realSupply, 0, nominalSupplyRaw - realSupply⟩

/-- The book says the mint ever issued exactly the nominal billion. -/
theorem chainBook_issued : chainBook.issued = nominalSupplyRaw := by
  simp only [chainBook, Book.issued, Book.outstanding]
  norm_num [nominalSupplyRaw, realSupply]

/-- **The cap holds for every possible future.**  Whatever holders lock, unlock,
burn or spend on badges, the tokens ever issued stay at the nominal billion. -/
theorem chain_supply_capped (as : List Book.Act) :
    (Book.run chainBook as).issued = nominalSupplyRaw := by
  rw [Book.run_issued, chainBook_issued]

/-- And the live supply can only fall from where the capture found it. -/
theorem chain_supply_only_falls (as : List Book.Act) :
    (Book.run chainBook as).outstanding ≤ realSupply := by
  have := Book.run_outstanding_le chainBook as
  simpa [chainBook, Book.outstanding] using this

end SFM.Token
