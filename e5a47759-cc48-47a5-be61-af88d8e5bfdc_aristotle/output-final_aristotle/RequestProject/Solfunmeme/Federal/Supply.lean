/-
  Supply.lean — the union against the mint's own numbers.

  `RequestProject/Federal/Facts.lean` builds the union out of the dataset's
  snapshot balances, rounded down to whole tokens.  This file checks that model
  against the two things the mint itself says, as captured in
  `dataset/` and transcribed in `RequestProject/Onchain/Data/Captures.lean`:
  the mint has six decimals, and its total supply is 999906030213118 raw units
  (999906030.213118 tokens).

  Two caveats, stated rather than hidden.  First, the snapshot balances and the
  supply capture are readings taken at different moments — the capture is at
  slot 336594291, the balances at the dataset's last snapshot — so the share
  computed below is a comparison of two datings, not a single observation.
  Second, the mint has no mint authority and no freeze authority
  (`Solana.CaptureFacts.mint_authorities_are_null`), so the supply is fixed and the
  comparison stays meaningful over time.

  What is proved:

    * `raw_apportionment_agrees` — apportioning the House by raw base units
      gives *exactly* the same 500 seats as apportioning it by whole tokens, so
      no state gains or loses a seat to the rounding in `stateTokens`;
    * `union_raw_stake`, `rounding_loses_less_than_a_token_per_senator` — what
      the rounding does cost;
    * `union_holds_more_than_half_the_supply` — the thirteen states together
      hold more than half of the mint's entire supply;
    * `union_share_bounds` — between 56% and 57% of it.
-/

import RequestProject.Solfunmeme.Federal.Facts
import RequestProject.Solfunmeme.Onchain.Data.Captures

namespace Federal.Union

open Badges.Claim Federal

/-! ### The same union, in raw base units -/

/-- A state's stake in raw base units, without the rounding to whole tokens. -/
def stateRaw (j : Nat) : Nat := ((cohort j).map (fun c => c.finalBalance)).sum

/-- The union, measured in raw base units. -/
def statesRaw : List Division :=
  List.zipWith (fun nm j => Division.mk nm (stateRaw j)) stateNames (List.range 13)

theorem union_raw_stake : totalPop statesRaw = 564653965307574 := by decide

/-- **The rounding costs nobody a seat.**  Apportioning the House by raw base
units returns exactly the apportionment by whole tokens. -/
theorem raw_apportionment_agrees : houseSeats statesRaw 500 = houseSeats states 500 := by decide

/-- The whole-token model understates the union's stake, and by less than one
token per senator: 100 senators, 50307574 raw units, under 100 tokens in all. -/
theorem rounding_loses_less_than_a_token_per_senator :
    totalPop states * 1000000 ≤ totalPop statesRaw ∧
      totalPop statesRaw - totalPop states * 1000000 < 100 * 1000000 := by decide

/-! ### The union against the mint's supply -/

/-- **The states hold more than half the supply.**  Their senators' closing
balances, in raw units, are more than half of everything the mint has ever
issued. -/
theorem union_holds_more_than_half_the_supply :
    Solana.Captures.realSupply < 2 * totalPop statesRaw := by decide

/-- The union never holds more than the supply. -/
theorem union_within_supply : totalPop statesRaw ≤ Solana.Captures.realSupply := by decide

/-- **Between 56% and 57% of the supply** sits with the thirteen states. -/
theorem union_share_bounds :
    (56 : ℚ) / 100 < (totalPop statesRaw : ℚ) / Solana.Captures.realSupply ∧
      (totalPop statesRaw : ℚ) / Solana.Captures.realSupply < 57 / 100 := by
  have hsupply : ((Solana.Captures.realSupply : ℚ)) = 999906030213118 := by
    simp [Solana.Captures.realSupply]
  rw [union_raw_stake, hsupply]
  constructor <;> rw [div_lt_div_iff₀ (by norm_num) (by norm_num)] <;> norm_num

end Federal.Union
