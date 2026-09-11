/-
  Tiers.lean — the tier structure of the "Proposed Federal DAO Model"
  (SOLFUNMEME issue #86), and the arithmetic of its golden-ratio claims.

  The proposal fixes three tiers by holder rank:

      Senate           ranks    1 –  100   (100 seats)
      Representatives  ranks  101 –  600   (500 seats)
      Vendors          ranks  601 – 1600  (1000 seats)

  and asserts that

    * "Senate to Representatives ratio: ~5x (close to φ³)",
    * "Representatives to Vendors ratio: ~2x (close to φ)",
    * "Total progression follows Fibonacci-like sequence: 100, 500, 1000".

  This file records the tier map and checks those three assertions.  The first
  two are quantified here (the errors are 18% and 24%); the third is false as
  stated, in both the per-tier and the cumulative reading.
-/

import Mathlib

namespace Badges

/-! ### The tier map -/

/-- The membership tiers of the proposal, plus `outside` for holders whose rank
carries no governance rights. -/
inductive Tier where
  | senate
  | representative
  | vendor
  | outside
  deriving DecidableEq, Repr

/-- Seats in the Senate tier. -/
def senateSeats : ℕ := 100
/-- Seats in the Representative tier. -/
def repSeats : ℕ := 500
/-- Seats in the Vendor tier. -/
def vendorSeats : ℕ := 1000
/-- Total number of ranks with a direct voice. -/
def votingSeats : ℕ := 1600

/-- The tier of a holder of rank `r` (rank 1 = largest holder; rank 0 means
"unranked"). -/
def tierOfRank (r : ℕ) : Tier :=
  if r = 0 then .outside
  else if r ≤ 100 then .senate
  else if r ≤ 600 then .representative
  else if r ≤ 1600 then .vendor
  else .outside

theorem tierOfRank_senate {r : ℕ} (h1 : 1 ≤ r) (h2 : r ≤ 100) :
    tierOfRank r = .senate := by
  unfold tierOfRank; split_ifs <;> first | rfl | omega

theorem tierOfRank_representative {r : ℕ} (h1 : 101 ≤ r) (h2 : r ≤ 600) :
    tierOfRank r = .representative := by
  unfold tierOfRank; split_ifs <;> first | rfl | omega

theorem tierOfRank_vendor {r : ℕ} (h1 : 601 ≤ r) (h2 : r ≤ 1600) :
    tierOfRank r = .vendor := by
  unfold tierOfRank; split_ifs <;> first | rfl | omega

/-- Every rank between 1 and 1600 is in exactly one of the three tiers. -/
theorem tier_exhaustive {r : ℕ} (h1 : 1 ≤ r) (h2 : r ≤ 1600) :
    tierOfRank r ≠ .outside := by
  unfold tierOfRank; split_ifs <;> simp_all

/-- Ranks past 1600 have no direct voice: "only the top 1600 at the moment are
planned to have any direct voice". -/
theorem no_voice_beyond_1600 {r : ℕ} (h : 1600 < r) : tierOfRank r = .outside := by
  unfold tierOfRank; split_ifs <;> first | rfl | omega

/-! ### The seat counts are what the proposal says -/

theorem senate_ranks :
    (Finset.Icc 1 1600).filter (fun r => tierOfRank r = .senate) = Finset.Icc 1 100 := by
  ext r
  simp only [Finset.mem_filter, Finset.mem_Icc]
  constructor
  · rintro ⟨⟨h1, h2⟩, h3⟩
    refine ⟨h1, ?_⟩
    by_contra hc
    rcases Nat.lt_or_ge r 601 with h | h
    · rw [tierOfRank_representative (by omega) (by omega)] at h3; simp at h3
    · rw [tierOfRank_vendor (by omega) (by omega)] at h3; simp at h3
  · rintro ⟨h1, h2⟩
    exact ⟨⟨h1, by omega⟩, tierOfRank_senate h1 h2⟩

theorem senate_seat_count :
    ((Finset.Icc 1 1600).filter (fun r => tierOfRank r = .senate)).card = senateSeats := by
  rw [senate_ranks]; simp [senateSeats]

theorem representative_ranks :
    (Finset.Icc 1 1600).filter (fun r => tierOfRank r = .representative)
      = Finset.Icc 101 600 := by
  ext r
  simp only [Finset.mem_filter, Finset.mem_Icc]
  constructor
  · rintro ⟨⟨h1, h2⟩, h3⟩
    refine ⟨?_, ?_⟩ <;> by_contra hc
    · rw [tierOfRank_senate (by omega) (by omega)] at h3; simp at h3
    · rw [tierOfRank_vendor (by omega) (by omega)] at h3; simp at h3
  · rintro ⟨h1, h2⟩
    exact ⟨⟨by omega, by omega⟩, tierOfRank_representative h1 h2⟩

theorem representative_seat_count :
    ((Finset.Icc 1 1600).filter (fun r => tierOfRank r = .representative)).card
      = repSeats := by
  rw [representative_ranks]; simp [repSeats]

theorem vendor_ranks :
    (Finset.Icc 1 1600).filter (fun r => tierOfRank r = .vendor) = Finset.Icc 601 1600 := by
  ext r
  simp only [Finset.mem_filter, Finset.mem_Icc]
  constructor
  · rintro ⟨⟨h1, h2⟩, h3⟩
    refine ⟨?_, h2⟩
    by_contra hc
    rcases Nat.lt_or_ge r 101 with h | h
    · rw [tierOfRank_senate (by omega) (by omega)] at h3; simp at h3
    · rw [tierOfRank_representative (by omega) (by omega)] at h3; simp at h3
  · rintro ⟨h1, h2⟩
    exact ⟨⟨by omega, h2⟩, tierOfRank_vendor h1 h2⟩

theorem vendor_seat_count :
    ((Finset.Icc 1 1600).filter (fun r => tierOfRank r = .vendor)).card = vendorSeats := by
  rw [vendor_ranks]; simp [vendorSeats]

theorem seats_sum : senateSeats + repSeats + vendorSeats = votingSeats := by decide

/-! ### The Fibonacci claim is false -/

/-- "Total progression follows Fibonacci-like sequence: 100, 500, 1000" — false:
a Fibonacci-like sequence would need 100 + 500 = 1000. -/
theorem tier_sizes_not_fibonacci : senateSeats + repSeats ≠ vendorSeats := by decide

/-- The cumulative reading (100, 600, 1600 holders) is not Fibonacci-like
either: 100 + 600 = 700 ≠ 1600. -/
theorem cumulative_sizes_not_fibonacci : 100 + 600 ≠ 1600 := by decide

/-- Nor is the progression geometric: the two successive ratios are 5 and 2. -/
theorem tier_ratios_differ :
    (repSeats : ℚ) / senateSeats ≠ (vendorSeats : ℚ) / repSeats := by
  norm_num [repSeats, senateSeats, vendorSeats]

/-- The reward multipliers 3x / 2x / 1x are not geometric either. -/
theorem reward_multipliers_not_geometric : (3 : ℚ) / 2 ≠ (2 : ℚ) / 1 := by norm_num

/-! ### How far the ratios are from powers of φ -/

theorem goldenRatio_bounds : (1.618 : ℝ) < Real.goldenRatio ∧ Real.goldenRatio < 1.6181 := by
  have h : Real.goldenRatio = (1 + Real.sqrt 5) / 2 := rfl
  constructor <;>
    · rw [h]
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 5), Real.sqrt_nonneg 5]

theorem goldenRatio_cube_bounds :
    (4.235 : ℝ) < Real.goldenRatio ^ 3 ∧ Real.goldenRatio ^ 3 < 4.2361 := by
  have h : Real.goldenRatio = (1 + Real.sqrt 5) / 2 := rfl
  constructor <;>
    · rw [h]
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 5), Real.sqrt_nonneg 5]

/-- The Senate-to-Representatives ratio is 5, which overshoots φ³ ≈ 4.236 by
more than 0.76 — an 18% error, not "close to φ³". -/
theorem senate_rep_ratio_off_from_phi_cubed :
    (0.76 : ℝ) < (repSeats : ℝ) / senateSeats - Real.goldenRatio ^ 3 := by
  have h := goldenRatio_cube_bounds.2
  have : ((repSeats : ℝ)) / senateSeats = 5 := by norm_num [repSeats, senateSeats]
  rw [this]
  linarith

/-- The Representatives-to-Vendors ratio is 2, which overshoots φ ≈ 1.618 by
more than 0.38 — a 24% error. -/
theorem rep_vendor_ratio_off_from_phi :
    (0.38 : ℝ) < (vendorSeats : ℝ) / repSeats - Real.goldenRatio := by
  have h := goldenRatio_bounds.2
  have : ((vendorSeats : ℝ)) / repSeats = 2 := by norm_num [repSeats, vendorSeats]
  rw [this]
  linarith

/-- An actual φ-progression starting from 100 seats gives 100, 161, 261 —
nothing like 100, 500, 1000. -/
theorem phi_progression_from_100 :
    ⌊(100 : ℝ) * Real.goldenRatio⌋ = 161 ∧ ⌊(100 : ℝ) * Real.goldenRatio ^ 2⌋ = 261 := by
  obtain ⟨h1, h2⟩ := goldenRatio_bounds
  constructor
  · rw [Int.floor_eq_iff]
    constructor <;> push_cast <;> linarith
  · have hsq : Real.goldenRatio ^ 2 = Real.goldenRatio + 1 := Real.goldenRatio_sq
    rw [Int.floor_eq_iff, hsq]
    constructor <;> push_cast <;> linarith

/-! ### The voting thresholds -/

/-- A tally in one chamber: how many members voted yes, out of how many seats. -/
structure Tally where
  yes : ℕ
  seats : ℕ
  deriving DecidableEq, Repr

/-- `t` reaches a `p` percent bar of its seats. -/
def Tally.reaches (t : Tally) (p : ℕ) : Prop := 100 * t.yes ≥ p * t.seats

instance (t : Tally) (p : ℕ) : Decidable (t.reaches p) := by
  unfold Tally.reaches; infer_instance

/-- Constitutional changes: 75% Senate + 60% Representatives. -/
def constitutionalPasses (s r : Tally) : Prop := s.reaches 75 ∧ r.reaches 60

/-- Major proposals: 60% Senate + 51% Representatives. -/
def majorPasses (s r : Tally) : Prop := s.reaches 60 ∧ r.reaches 51

/-- Operational decisions: 51% Representatives + 51% Vendors — the Senate has no
vote at all. -/
def operationalPasses (r v : Tally) : Prop := r.reaches 51 ∧ v.reaches 51

theorem reaches_mono {t : Tally} {p q : ℕ} (hpq : q ≤ p) (h : t.reaches p) :
    t.reaches q := le_trans (Nat.mul_le_mul_right _ hpq) h

/-- Constitutional approval implies the (weaker) major-proposal approval. -/
theorem constitutional_implies_major {s r : Tally} (h : constitutionalPasses s r) :
    majorPasses s r :=
  ⟨reaches_mono (by norm_num) h.1, reaches_mono (by norm_num) h.2⟩

/-- The Senate cannot enact a major proposal on its own: unanimity in the Senate
with no Representative support fails. -/
theorem senate_alone_cannot_enact (n : ℕ) (hn : 0 < n) :
    ¬ majorPasses ⟨senateSeats, senateSeats⟩ ⟨0, n⟩ := by
  rintro ⟨-, h2⟩
  simp only [Tally.reaches] at h2
  omega

/-- Operational decisions bypass the Senate entirely: they can pass with zero
Senate involvement, so the Senate's "veto power over Representative proposals"
does not reach them. -/
theorem operational_bypasses_senate :
    operationalPasses ⟨repSeats, repSeats⟩ ⟨vendorSeats, vendorSeats⟩ := by
  constructor <;> simp [Tally.reaches, repSeats, vendorSeats]

/-- The Senate veto (60% of the Senate) is redundant for major proposals: a
proposal that clears the 60% Senate bar cannot simultaneously be vetoed by 60%
of the Senate, since no senator votes twice. -/
theorem senate_veto_redundant_for_major (s r : Tally) (veto : ℕ)
    (hsum : s.yes + veto ≤ s.seats) (hseats : 0 < s.seats)
    (hpass : majorPasses s r) (hveto : 100 * veto ≥ 60 * s.seats) : False := by
  have h1 : 100 * s.yes ≥ 60 * s.seats := hpass.1
  omega

end Badges
