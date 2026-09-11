/-
  TierProperties.lean — the tier ladder of `lean4/FederalModel.lean`, checked
  against the published holder data.

  Upstream states the Fibonacci recurrence as nine standalone arithmetic facts
  (`fib_at_3 : 1000 + 500 = 1500`, …) which mention neither `tierBoundaries` nor
  any index, and comments them as "recurrence from index 1 onward"; `assignTier`
  is declared "exhaustive" in a comment with no theorem attached.

  Here the recurrence is stated about the list itself (and shown to fail at the
  first index, which the comment claims it holds at), `assignTier` is characterised
  by the boundaries, and the tier histogram published in
  `proofs/holder_identities.json` (100 diamond, 400 gold, 500 silver, 500 fib-3,
  476 fib-4 over 1976 holders) is derived from the boundary list.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Upstream.FederalModel

namespace Review.Tier

set_option maxHeartbeats 4000000

/-! ### The recurrence, stated about `tierBoundaries` -/

/-- `b[n+2] = b[n+1] + b[n]` holds for every index from 1 to 9. -/
theorem tierBoundaries_fib : ∀ n, n < 10 → 1 ≤ n →
    tierBoundaries[n + 2]! = tierBoundaries[n + 1]! + tierBoundaries[n]! := by decide

/-- It fails at index 0: `100 + 500 = 600 ≠ 1000`.  The first three entries
    `[100, 500, 1000]` are seeded, not generated. -/
theorem tierBoundaries_fib_fails_at_zero :
    tierBoundaries[2]! ≠ tierBoundaries[1]! + tierBoundaries[0]! := by decide

theorem tierBoundaries_strictMono : tierBoundaries.Pairwise (· < ·) := by decide

/-! ### `assignTier` is exactly the boundary lookup -/

theorem assignTier_diamond_iff (r : Nat) : assignTier r = "diamond" ↔ r < 100 := by
  unfold assignTier
  split_ifs with h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 <;> simp <;> omega

theorem assignTier_gold_iff (r : Nat) : assignTier r = "gold" ↔ 100 ≤ r ∧ r < 500 := by
  unfold assignTier
  split_ifs with h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 <;> simp <;> omega

theorem assignTier_silver_iff (r : Nat) : assignTier r = "silver" ↔ 500 ≤ r ∧ r < 1000 := by
  unfold assignTier
  split_ifs with h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 <;> simp <;> omega

theorem assignTier_community_iff (r : Nat) : assignTier r = "community" ↔ 72000 ≤ r := by
  unfold assignTier
  split_ifs with h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 <;> simp <;> omega

/-- The "exhaustive" comment, as a theorem: every rank gets one of the thirteen
    tier names. -/
theorem assignTier_mem (r : Nat) :
    assignTier r ∈ ["diamond", "gold", "silver", "fib-3", "fib-4", "fib-5", "fib-6",
      "fib-7", "fib-8", "fib-9", "fib-10", "fib-11", "community"] := by
  unfold assignTier
  split_ifs <;> simp

/-! ### The published tier histogram follows from the boundaries

    `proofs/holder_identities.json` ranks 1976 holders and reports
    100 diamond, 400 gold, 500 silver, 500 fib-3 and 476 fib-4.  With
    `tierSize` = number of ranks of a tier that a population of `n` holders fills,
    those five numbers are forced by `tierBoundaries`. -/

/-- Number of holders of a population of size `n` whose rank lies in `[lo, hi)`. -/
def tierSize (n lo hi : Nat) : Nat := min n hi - min n lo

theorem holder_histogram :
    tierSize 1976 0 100 = 100 ∧ tierSize 1976 100 500 = 400 ∧
    tierSize 1976 500 1000 = 500 ∧ tierSize 1976 1000 1500 = 500 ∧
    tierSize 1976 1500 2500 = 476 ∧ tierSize 1976 2500 4000 = 0 := by decide

theorem holder_histogram_total :
    tierSize 1976 0 100 + tierSize 1976 100 500 + tierSize 1976 500 1000 +
      tierSize 1976 1000 1500 + tierSize 1976 1500 2500 = 1976 := by decide

/-- The three "human" chambers of the README (top 100, next 500, next 1000) do not
    line up with the tier boundaries: ranks 101–500 are 400 holders, not 500, and
    ranks 501–1000 are 500 holders, not 1000. -/
theorem chamber_sizes_disagree_with_boundaries :
    tierSize 100000 100 500 ≠ 500 ∧ tierSize 100000 500 1000 ≠ 1000 := by decide

end Review.Tier
