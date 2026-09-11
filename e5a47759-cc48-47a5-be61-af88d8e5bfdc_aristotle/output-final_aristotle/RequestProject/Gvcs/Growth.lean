import Mathlib

/-!
# Bootstrapping the player base

The arithmetic behind the launch plan in
`docs/bootstrap-and-certified-mode.md`.  The model is the standard one and it
is deliberately small, because the conclusions it forces are the ones the plan
has to respect.

Each round (a week, say) the population `u` of active players turns over: each
active player brings in `k` new active players — the **viral coefficient**,
`invites × conversion × retention` — and `s` new players arrive from outside
(the seeding: posts, videos, the open-hardware community, paid acquisition).

* `users_le_fixedPoint` — if `k < 1` the population never passes `s / (1 - k)`,
  whatever you do.  Sub-critical loops *plateau*, and the plateau is set by how
  hard you push from outside, not by how good the loop is.
* `fixedPoint_stationary` — that ceiling is exactly the stationary population.
* `users_unbounded` — if `k > 1` the population passes every bound, even with
  no outside seeding at all.  Crossing `k = 1` is the whole game.
* `cohort_total_le` — a single seeded player, in a sub-critical loop, is worth
  `1 / (1 - k)` players in total: the multiplier the launch budget is spent
  against.
* `viralCoefficient_gt_one_iff` — what `k > 1` costs in terms of invitations
  sent, conversion and retention.
* `breakEven_iff` — a fixed monthly cost `F` and a contribution `r` per active
  player break even exactly at `F / r` players.
-/

namespace LifeTrac
namespace Growth

/-- The active population after `n` rounds: each player brings `k` more, and
`s` arrive from outside each round. -/
def users (u₀ s k : ℚ) : ℕ → ℚ
  | 0 => u₀
  | n + 1 => k * users u₀ s k n + s

@[simp] theorem users_zero (u₀ s k : ℚ) : users u₀ s k 0 = u₀ := rfl

@[simp] theorem users_succ (u₀ s k : ℚ) (n : ℕ) :
    users u₀ s k (n + 1) = k * users u₀ s k n + s := rfl

/-- The population a sub-critical loop settles at. -/
def fixedPoint (s k : ℚ) : ℚ := s / (1 - k)

/-- The fixed point deserves its name: a population of `s / (1 - k)` reproduces
itself exactly. -/
theorem fixedPoint_stationary {s k : ℚ} (hk : k ≠ 1) :
    k * fixedPoint s k + s = fixedPoint s k := by
  have h : (1 : ℚ) - k ≠ 0 := sub_ne_zero.mpr (Ne.symm hk)
  unfold fixedPoint
  field_simp
  ring

/-- **A sub-critical loop plateaus.**  With `k < 1`, the population never
exceeds `s / (1 - k)` — the ceiling is set by the outside seeding, and no
amount of time inside the loop gets past it. -/
theorem users_le_fixedPoint {u₀ s k : ℚ} (hk0 : 0 ≤ k) (hk1 : k < 1)
    (hu : u₀ ≤ fixedPoint s k) (n : ℕ) : users u₀ s k n ≤ fixedPoint s k := by
  induction n with
  | zero => exact hu
  | succ n ih =>
      have hstep : k * users u₀ s k n + s ≤ k * fixedPoint s k + s := by
        have := mul_le_mul_of_nonneg_left ih hk0
        linarith
      rw [users_succ]
      calc k * users u₀ s k n + s ≤ k * fixedPoint s k + s := hstep
        _ = fixedPoint s k := fixedPoint_stationary (by linarith)

/-- A super-critical loop dominates pure exponential growth. -/
theorem pow_mul_le_users {u₀ s k : ℚ} (hk : 0 ≤ k) (hs : 0 ≤ s) (n : ℕ) :
    k ^ n * u₀ ≤ users u₀ s k n := by
  induction n with
  | zero => simp
  | succ n ih =>
      have h1 : k * (k ^ n * u₀) ≤ k * users u₀ s k n := mul_le_mul_of_nonneg_left ih hk
      rw [users_succ, pow_succ]
      nlinarith

/-- **A super-critical loop compounds.**  With `k > 1` and a single genuine
player to start from, the population passes every bound — with no outside
seeding at all. -/
theorem users_unbounded {u₀ s k : ℚ} (hk : 1 < k) (hu : 0 < u₀) (hs : 0 ≤ s) (M : ℚ) :
    ∃ n, M < users u₀ s k n := by
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (M / u₀) hk
  refine ⟨n, lt_of_lt_of_le ?_ (pow_mul_le_users (by linarith) hs n)⟩
  rw [div_lt_iff₀ hu] at hn
  linarith

/-- The total number of players that ever come from one seeded player, over
`n` rounds of a loop with coefficient `k`. -/
def cohortTotal (k : ℚ) (n : ℕ) : ℚ := ∑ i ∈ Finset.range n, k ^ i

/-- **What one seeded player is worth.**  In a sub-critical loop, a player
brought in from outside is worth at most `1 / (1 - k)` players in total: the
multiplier that the launch budget buys. -/
theorem cohortTotal_le {k : ℚ} (hk0 : 0 ≤ k) (hk1 : k < 1) (n : ℕ) :
    cohortTotal k n ≤ 1 / (1 - k) := by
  have hk : k ≠ 1 := ne_of_lt hk1
  have hsum : cohortTotal k n = (k ^ n - 1) / (k - 1) := geom_sum_eq hk n
  have h1 : (0 : ℚ) < 1 - k := by linarith
  have h2 : (0 : ℚ) ≤ k ^ n := pow_nonneg hk0 n
  have hne : (1 : ℚ) - k ≠ 0 := ne_of_gt h1
  have key : (k ^ n - 1) / (k - 1) = (1 - k ^ n) / (1 - k) := by
    rw [show (1 : ℚ) - k ^ n = -(k ^ n - 1) by ring, show (1 : ℚ) - k = -(k - 1) by ring,
      neg_div_neg_eq]
  rw [hsum, key, ← sub_nonneg]
  have hdiff : 1 / (1 - k) - (1 - k ^ n) / (1 - k) = k ^ n / (1 - k) := by
    field_simp
    ring
  rw [hdiff]
  exact div_nonneg h2 (le_of_lt h1)

/-- The viral coefficient as it is actually measured: invitations sent per
player, times the fraction that convert, times the fraction that stay. -/
def viralCoefficient (invites conversion retention : ℚ) : ℚ :=
  invites * conversion * retention

/-- What "the loop compounds" costs in practice. -/
theorem viralCoefficient_gt_one_iff {invites conversion retention : ℚ}
    (hi : 0 < invites) (hc : 0 < conversion) :
    1 < viralCoefficient invites conversion retention ↔
      1 / (invites * conversion) < retention := by
  rw [viralCoefficient, div_lt_iff₀ (by positivity), mul_comm]

/-- **Break-even.**  A fixed cost `F` per round against a contribution `r` per
active player is covered exactly from `F / r` players on. -/
theorem breakEven_iff {F r u : ℚ} (hr : 0 < r) : F ≤ r * u ↔ F / r ≤ u := by
  rw [div_le_iff₀ hr, mul_comm]

end Growth
end LifeTrac
