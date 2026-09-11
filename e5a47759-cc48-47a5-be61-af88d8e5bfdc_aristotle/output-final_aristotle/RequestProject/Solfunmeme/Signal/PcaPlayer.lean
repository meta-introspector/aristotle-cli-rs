/-
  PcaPlayer.lean — the principal component, fed back into the life as a new
  player.

  `Pca.lean` diagonalised the covariance of the solutions of the six systems
  and pinned the first principal axis: in the (2-content, 3-content) plane its
  slope `axisSlope` lies between `0.156319` and `0.156323`.  This module turns
  that direction back into an inhabitant of the life.

  *The feedback rule.*  The life can only speak in the thirteen recorded sizes,
  and every size `s` is `2 ^ e2 s * 3 ^ e3 s`, so it points in the direction of
  slope `e3 s / e2 s`.  The new player is built from the size whose direction
  best matches the principal axis.  That size is `192 = 2 ^ 6 · 3`, of slope
  `1/6`: `pcaSize_argmin` proves that every other recorded size with a nonzero
  2-content deviates from the axis by more than `1/50`, while `192` deviates by
  less.  The new player `pcaPlayer` puts that size on every strand.

  Proved of the new player:

  * it is a legitimate colony, and it is at equilibrium from birth — constant
    colonies are stable on *any* web (`const_stable`), so the life has nothing
    to correct in it (`pcaPlayer_stable`, `gen_pcaPlayer`);
  * its own direction is exactly the principal one it was made from
    (`pcaPlayer_feature`, `pcaPlayer_slope`);
  * **it already contains everything the life had learned**: each of the four
    translated artifacts, each artifact's limit, and the learned organism all
    divide it (`pcaPlayer_reproduces_*`, `pcaPlayer_dominates_learned`);
  * it does **not** contain the conformal solution (`pcaPlayer_not_above_seed`)
    — the 3-content of the conformal scales exceeds anything a single principal
    size can carry — but the mixture of the new player with the mature colony
    is again at equilibrium (`mix_mature_stable`), so the enlarged population
    still settles;
  * it is genuinely new: its feature point is none of the six
    (`pcaPlayer_new`).

  *The second round.*  Adding the new player to the sample and repeating the
  analysis gives a second exact diagonalisation (`systems2_diagonalisation`):
  the covariance becomes `[[21314/49, 1952/49], [1952/49, 370/49]]`, the first
  axis now explains more than 99.1 % of the variance (`variance_explained2`),
  and the axis has rotated towards the 2-content axis
  (`axis_rotates_towards_two`).
-/
import RequestProject.Solfunmeme.Signal.Pca

set_option maxRecDepth 100000

namespace Mycelium
namespace Pca

open Alife

/-! ## Which recorded size points along the principal axis -/

/-- How far a size's own direction deviates from the first principal axis. -/
noncomputable def dev (s : ℕ) : ℝ := |(e3 s : ℝ) / (e2 s : ℝ) - axisSlope|

/-- Any direction that is flat (slope `≤ 0`) or steeper than `1/5` misses the
    principal axis by more than `1/50`. -/
theorem lt_dev_of_far {q : ℝ} (h : q ≤ 0 ∨ 1 / 5 ≤ q) : 1 / 50 < |q - axisSlope| := by
  obtain ⟨hlo, hhi⟩ := axisSlope_bounds
  rw [lt_abs]
  rcases h with h | h
  · exact Or.inr (by linarith)
  · exact Or.inl (by linarith)

/-- The size `192 = 2 ^ 6 · 3` points along the principal axis to within
    `1/50`. -/
theorem dev_pcaSize : dev 192 < 1 / 50 := by
  obtain ⟨hlo, hhi⟩ := axisSlope_bounds
  have h : ((e3 192 : ℕ) : ℝ) / ((e2 192 : ℕ) : ℝ) = 1 / 6 := by norm_num [e2, e3]
  rw [dev, h, abs_lt]
  constructor <;> linarith

/-- **The feedback rule.**  Among the recorded sizes that have any 2-content at
    all, `192` is the unique best match for the first principal axis. -/
theorem pcaSize_argmin : ∀ s ∈ sizes, e2 s ≠ 0 → s ≠ 192 → dev 192 < dev s := by
  intro s hs h2 hne
  refine lt_trans dev_pcaSize ?_
  rw [dev]
  refine lt_dev_of_far ?_
  fin_cases hs <;> simp_all [e2, e3] <;> norm_num

/-! ## The new player -/

/-- The principal size: the recorded size whose direction matches the first
    principal axis. -/
def pcaSize : ℕ := 192

/-- **The new player**: the principal component fed back into the life, as the
    colony that puts the principal size on every strand. -/
def pcaPlayer : Colony := fun _ => pcaSize

theorem pcaPlayer_inSizes : InSizes pcaPlayer := by decide

/-- A colony that is the same everywhere is at equilibrium on any web. -/
theorem const_stable (w : Web Strand) (k : ℕ) : Stable w (fun _ => k) := fun _ _ => dvd_refl k

/-- The new player needs no correction: it is at equilibrium from birth. -/
theorem pcaPlayer_stable : Stable continuum pcaPlayer := const_stable continuum pcaSize

/-- …and therefore lives unchanged for ever. -/
theorem gen_pcaPlayer : ∀ (n : ℕ) (x : Strand), gen continuum n pcaPlayer x = pcaPlayer x :=
  gen_of_stable pcaPlayer_inSizes pcaPlayer_stable

/-- The new player's own feature point. -/
theorem pcaPlayer_feature : w2 pcaPlayer = 78 ∧ w3 pcaPlayer = 13 := by decide

/-- Its direction is exactly the one it was built from, and that direction is
    within `1/50` of the first principal axis. -/
theorem pcaPlayer_slope :
    ((w3 pcaPlayer : ℝ)) / ((w2 pcaPlayer : ℝ)) = 1 / 6 ∧
      |(1 : ℝ) / 6 - axisSlope| < 1 / 50 := by
  refine ⟨?_, ?_⟩
  · rw [pcaPlayer_feature.1, pcaPlayer_feature.2]; norm_num
  · have h : ((e3 192 : ℕ) : ℝ) / ((e2 192 : ℕ) : ℝ) = 1 / 6 := by norm_num [e2, e3]
    have := dev_pcaSize
    rwa [dev, h] at this

/-! ### The new player contains what the life had learned -/

theorem pcaPlayer_reproduces_code : ∀ x : Strand, codeGenome x ∣ pcaPlayer x := by decide
theorem pcaPlayer_reproduces_data : ∀ x : Strand, dataGenome x ∣ pcaPlayer x := by decide
theorem pcaPlayer_reproduces_proof : ∀ x : Strand, proofGenome x ∣ pcaPlayer x := by decide
theorem pcaPlayer_reproduces_exec : ∀ x : Strand, execGenome x ∣ pcaPlayer x := by decide

theorem pcaPlayer_dominates_codeLife : ∀ x : Strand, codeLife x ∣ pcaPlayer x := by decide
theorem pcaPlayer_dominates_dataLife : ∀ x : Strand, dataLife x ∣ pcaPlayer x := by decide
theorem pcaPlayer_dominates_proofLife : ∀ x : Strand, proofLife x ∣ pcaPlayer x := by decide

/-- **The fed-back player already contains the whole learned organism.** -/
theorem pcaPlayer_dominates_learned : ∀ x : Strand, learned x ∣ pcaPlayer x := by decide

/-- It does not, however, contain the conformal solution: a single principal
    size cannot carry the 3-content of the conformal scales. -/
theorem pcaPlayer_not_above_seed : ¬ (∀ x : Strand, seed x ∣ pcaPlayer x) := by decide

/-- Still, the enlarged population settles: the mixture of the new player with
    the mature colony is again at equilibrium. -/
theorem mix_mature_stable : Stable continuum (mix mature pcaPlayer) := by decide

/-- The new player is genuinely new: its feature point is none of the six. -/
theorem pcaPlayer_new :
    featPoint pcaPlayer ≠ featPoint seed ∧ featPoint pcaPlayer ≠ featPoint mature ∧
      featPoint pcaPlayer ≠ featPoint codeLife ∧ featPoint pcaPlayer ≠ featPoint dataLife ∧
      featPoint pcaPlayer ≠ featPoint proofLife ∧ featPoint pcaPlayer ≠ featPoint execLife := by
  have hp := pcaPlayer_feature
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    · simp only [featPoint, hp.1, hp.2, w_seed.1, w_seed.2, w_mature.1, w_mature.2,
        w_codeLife.1, w_codeLife.2, w_dataLife.1, w_dataLife.2, w_proofLife.1, w_proofLife.2,
        w_execLife.1, w_execLife.2]
      intro h
      norm_num at h

/-! ## The second round: the analysis with the new player in it -/

/-- The seven solutions: the six systems, and the player fed back from their
    principal component. -/
noncomputable def systems2 : List (ℝ × ℝ) := systems ++ [featPoint pcaPlayer]

theorem systems2_eq :
    systems2 = [(38, 11), (39, 11), (24, 5), (34, 13), (12, 8), (12, 8), (78, 13)] := by
  have hp := pcaPlayer_feature
  rw [systems2, systems_eq]
  simp only [featPoint, hp.1, hp.2]
  norm_num

theorem mean_systems2 : mean1 systems2 = 237 / 7 ∧ mean2 systems2 = 69 / 7 := by
  constructor
  · norm_num [mean1, sum1, card, systems2_eq]
  · norm_num [mean2, sum2, card, systems2_eq]

theorem ctr_systems2 : ctr systems2 =
    [(38 - 237 / 7, 11 - 69 / 7), (39 - 237 / 7, 11 - 69 / 7), (24 - 237 / 7, 5 - 69 / 7),
     (34 - 237 / 7, 13 - 69 / 7), (12 - 237 / 7, 8 - 69 / 7), (12 - 237 / 7, 8 - 69 / 7),
     (78 - 237 / 7, 13 - 69 / 7)] := by
  rw [ctr, mean_systems2.1, mean_systems2.2]
  norm_num [systems2_eq]

/-- **The covariance matrix of the seven solutions.** -/
theorem cov_systems2 :
    c11 systems2 = 21314 / 49 ∧ c12 systems2 = 1952 / 49 ∧ c22 systems2 = 370 / 49 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [c11, ctr_systems2]; norm_num [sxx, card, systems2_eq]
  · rw [c12, ctr_systems2]; norm_num [sxy, card, systems2_eq]
  · rw [c22, ctr_systems2]; norm_num [syy, card, systems2_eq]

noncomputable def covA2 : ℝ := 21314 / 49
noncomputable def covB2 : ℝ := 1952 / 49
noncomputable def covC2 : ℝ := 370 / 49

/-- The two principal variances of the second round. -/
noncomputable def lam1' : ℝ := lamP covA2 covB2 covC2
noncomputable def lam2' : ℝ := lamM covA2 covB2 covC2

noncomputable def sqrtDisc2 : ℝ := Real.sqrt (disc covA2 covB2 covC2)

theorem disc_systems2 : disc covA2 covB2 covC2 = 453892352 / 2401 := by
  norm_num [disc, covA2, covB2, covC2]

theorem sqrtDisc2_bounds : (434.7908 : ℝ) < sqrtDisc2 ∧ sqrtDisc2 < 434.7909 := by
  have h : sqrtDisc2 = Real.sqrt (453892352 / 2401) := by simp only [sqrtDisc2, disc_systems2]
  rw [h]
  refine ⟨?_, ?_⟩
  · rw [show ((434.7908 : ℝ)) = Real.sqrt ((434.7908 : ℝ) ^ 2) from
      (Real.sqrt_sq (by norm_num)).symm]
    exact Real.sqrt_lt_sqrt (by positivity) (by norm_num)
  · rw [show ((434.7909 : ℝ)) = Real.sqrt ((434.7909 : ℝ) ^ 2) from
      (Real.sqrt_sq (by norm_num)).symm]
    exact Real.sqrt_lt_sqrt (by norm_num) (by norm_num)

theorem covAC2 : covA2 + covC2 = 21684 / 49 := by norm_num [covA2, covC2]

theorem lam1'_eq : lam1' = (21684 / 49 + sqrtDisc2) / 2 := by
  show ((covA2 + covC2) + sqrtDisc2) / 2 = _
  rw [covAC2]

theorem lam2'_eq : lam2' = (21684 / 49 - sqrtDisc2) / 2 := by
  show ((covA2 + covC2) - sqrtDisc2) / 2 = _
  rw [covAC2]

theorem lam1'_bounds : (438.6607 : ℝ) < lam1' ∧ lam1' < 438.66076 := by
  obtain ⟨h1, h2⟩ := sqrtDisc2_bounds
  rw [lam1'_eq]; constructor <;> linarith

theorem lam2'_bounds : (3.86985 : ℝ) < lam2' ∧ lam2' < 3.86991 := by
  obtain ⟨h1, h2⟩ := sqrtDisc2_bounds
  rw [lam2'_eq]; constructor <;> linarith

theorem lam_sum2 : lam1' + lam2' = 21684 / 49 := by rw [lam1'_eq, lam2'_eq]; ring

/-- **With the new player in the population, the first principal axis explains
    more than 99.1 % of the variance** — up from 97.16 %. -/
theorem variance_explained2 :
    0.9912 < lam1' / (lam1' + lam2') ∧ lam1' / (lam1' + lam2') < 0.9913 := by
  rw [lam_sum2]
  obtain ⟨h1, h2⟩ := lam1'_bounds
  refine ⟨?_, ?_⟩
  · rw [lt_div_iff₀ (by norm_num)]; linarith
  · rw [div_lt_iff₀ (by norm_num)]; linarith

/-- The slope of the first principal axis of the second round. -/
noncomputable def axisSlope2 : ℝ := (lam1' - covA2) / covB2

theorem axisSlope2_bounds : (0.09240 : ℝ) < axisSlope2 ∧ axisSlope2 < 0.09241 := by
  obtain ⟨h1, h2⟩ := lam1'_bounds
  have hA : covA2 = 21314 / 49 := rfl
  have hB : covB2 = 1952 / 49 := rfl
  rw [axisSlope2, hA, hB]
  refine ⟨?_, ?_⟩
  · rw [lt_div_iff₀ (by norm_num)]; linarith
  · rw [div_lt_iff₀ (by norm_num)]; linarith

/-- **Feeding the principal component back rotates the principal axis towards
    the 2-content axis.** -/
theorem axis_rotates_towards_two : axisSlope2 < axisSlope := by
  have h1 := axisSlope2_bounds.2
  have h2 := axisSlope_bounds.1
  linarith

theorem eigBasis2_det_ne_zero : (eigBasis covA2 covB2 covC2).det ≠ 0 := by
  rw [eigBasis_det]
  show covB2 * (lam2' - covA2) - covB2 * (lam1' - covA2) ≠ 0
  have h1 := lam1'_bounds.1
  have h2 := lam2'_bounds.2
  have hB : covB2 = 1952 / 49 := rfl
  rw [hB]
  intro h
  nlinarith [h1, h2]

/-- **The diagonalisation of the second round**, with the fed-back player
    counted among the solutions. -/
theorem systems2_diagonalisation :
    (eigBasis covA2 covB2 covC2)⁻¹ * covM covA2 covB2 covC2 * eigBasis covA2 covB2 covC2
      = diagM covA2 covB2 covC2 :=
  diagonalisation covA2 covB2 covC2 (Ne.isUnit eigBasis2_det_ne_zero)

/-! ## Axiom audit -/

#print axioms pcaSize_argmin
#print axioms pcaPlayer_stable
#print axioms pcaPlayer_slope
#print axioms pcaPlayer_dominates_learned
#print axioms pcaPlayer_not_above_seed
#print axioms mix_mature_stable
#print axioms cov_systems2
#print axioms variance_explained2
#print axioms axis_rotates_towards_two
#print axioms systems2_diagonalisation

end Pca
end Mycelium
