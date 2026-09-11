import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinAlgebra_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root

/-!
# Orbit-to-ideal bijection for Eisenstein integers

This file proves that for `n ≥ 1`:
  `eisNormCount n = 6 * idealCount n`
-/

noncomputable section

open scoped Classical

namespace Eisenstein

open EisensteinThetaBridge EisensteinOrbit EisensteinUnits

/-! ## Bounds on coordinates given norm -/

theorem norm_bound_b (z : Eisenstein) (n : ℕ) (hn : Eisenstein.norm z = (n : ℤ)) :
    |z.b| ≤ (n : ℤ) + 1 := by
  have h4 : 4 * Eisenstein.norm z = (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 := by
    unfold Eisenstein.norm; ring
  have hb2 : 3 * z.b ^ 2 ≤ 4 * (n : ℤ) := by nlinarith [sq_nonneg (2 * z.a - z.b)]
  have hnn : 4 * (n : ℤ) ≤ 3 * ((n : ℤ) + 1) ^ 2 := by nlinarith [sq_nonneg (n : ℤ)]
  exact abs_le_of_sq_le_sq (by nlinarith) (by positivity)

theorem norm_bound_a (z : Eisenstein) (n : ℕ) (hn : Eisenstein.norm z = (n : ℤ)) :
    |z.a| ≤ (n : ℤ) + 1 := by
  have hnorm : z.a ^ 2 - z.a * z.b + z.b ^ 2 = (n : ℤ) := hn
  have ha2 : z.a ^ 2 ≤ 2 * (n : ℤ) := by nlinarith [sq_nonneg (z.a - z.b)]
  have hle : 2 * (n : ℤ) ≤ ((n : ℤ) + 1) ^ 2 := by nlinarith [sq_nonneg (n : ℤ)]
  exact abs_le_of_sq_le_sq (by nlinarith) (by positivity)

/-! ## Membership characterization of eisNormSet -/

theorem mem_eisNormSet_iff (z : Eisenstein) (n : ℕ) :
    z ∈ eisNormSet n ↔ Eisenstein.norm z = (n : ℤ) := by
  constructor;
  · unfold eisNormSet; aesop;
  · intro hz
    unfold eisNormSet;
    erw [ Finset.mem_filter, Finset.mem_image ];
    refine' ⟨ ⟨ ⟨ z.a, z.b ⟩, _, _ ⟩, hz ⟩ <;> norm_num;
    have := norm_bound_a z n hz; have := norm_bound_b z n hz; norm_num [ abs_le ] at *; omega;

/-! ## Key lemmas about ideals and associates -/

theorem absNorm_span_of_norm_eq (z : Eisenstein) (n : ℕ)
    (hn : Eisenstein.norm z = (n : ℤ)) :
    Ideal.absNorm (Ideal.span {z} : Ideal Eisenstein) = n := by
  rw [Eisenstein.absNorm_span_singleton, hn]
  exact Int.natAbs_natCast n

/-- Unit multiples preserve norm. -/
theorem norm_unit_mul (u : Eisensteinˣ) (z : Eisenstein) :
    Eisenstein.norm ((u : Eisenstein) * z) = Eisenstein.norm z := by
  rw [norm_mul, norm_eq_one_of_isUnit (u : Eisenstein) (Units.isUnit u), one_mul]

/-
Elements in the same unit orbit generate the same ideal.
-/
theorem orbit_same_ideal (z u : Eisenstein) (hu : u ∈ unitSet) :
    Ideal.span ({u * z} : Set Eisenstein) = Ideal.span {z} := by
  -- Since $u$ is a � unit�, there exists some $v$ such that $u * v = 1$.
  obtain ⟨v, hv⟩ : ∃ v : Eisenstein, u * v = 1 := by
    exact IsUnit.exists_right_inv ( mem_unitSet_iff_isUnit u |>.1 hu );
  refine' le_antisymm _ _ <;> rw [ Ideal.span_singleton_le_span_singleton ];
  · exact dvd_mul_left _ _;
  · exact ⟨ v, by linear_combination' -z * hv ⟩

/-
Elements generating the same ideal (both nonzero) differ by a unit.
-/
theorem same_ideal_implies_unit_mul (z w : Eisenstein) (hz : z ≠ 0)
    (hI : Ideal.span ({z} : Set Eisenstein) = Ideal.span {w}) :
    ∃ u ∈ unitSet, u * z = w := by
  have h_assoc : Associated z w := by
    exact?;
  obtain ⟨ u, hu ⟩ := h_assoc;
  exact ⟨ u, by simp [ mem_unitSet_iff_isUnit ], by simpa [ mul_comm ] using hu ⟩

/-
Every ideal of absNorm n (with n ≥ 1) is principal with a generator of norm n.
-/
theorem ideal_has_norm_generator (I : Ideal Eisenstein) (n : ℕ) (hn : 0 < n)
    (hI : Ideal.absNorm I = n) :
    ∃ z : Eisenstein, Eisenstein.norm z = (n : ℤ) ∧ I = Ideal.span {z} := by
  -- Since Eisenstein is a PID (IsPrincipal �Ideal�Ring), every ideal I is principal. Get a generator g with I = span {g}.
  obtain ⟨g, hg⟩ : ∃ g : Eisenstein, I = Ideal.span {g} := by
    exact?;
  refine' ⟨ g, _, hg ⟩;
  rw [ ← hI, hg, absNorm_span_singleton ];
  rw [ Int.natAbs_of_nonneg ( Eisenstein.norm_nonneg g ) ]

/-
The main counting theorem.
-/
theorem eisNormCount_eq_six_mul_idealCount' (n : ℕ) (hn : 0 < n) :
    eisNormCount n = 6 * (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) n).toFinset.card := by
  have h_orbit_card : ∀ z ∈ eisNormSet n, (Finset.filter (fun w => Ideal.span {w} = Ideal.span {z}) (eisNormSet n)).card = 6 := by
    intro z hz
    have h_orbit : Finset.filter (fun w => Ideal.span {w} = Ideal.span {z}) (eisNormSet n) = Finset.image (fun u => u * z) unitSet := by
      ext w;
      constructor <;> intro hw;
      · simp +zetaDelta at *;
        have := same_ideal_implies_unit_mul z w (by
        intro h; simp_all +decide [ eisNormSet ] ;
        linarith) hw.2.symm; aesop;
      · obtain ⟨ u, hu, rfl ⟩ := Finset.mem_image.mp hw;
        simp_all +decide [ mem_eisNormSet_iff ];
        exact ⟨ by rw [ norm_mul, show norm u = 1 from by rw [ mem_unitSet_iff_norm_one ] at hu; exact hu ] ; linarith, by rw [ orbit_same_ideal z u hu ] ⟩;
    rw [ h_orbit, Finset.card_image_of_injective ];
    · rfl;
    · intro u v huv;
      have h_nonzero : z ≠ 0 := by
        intro h; simp_all +decide [ eisNormSet ] ;
        grind +splitIndPred;
      exact mul_right_cancel_of_ne_zero h_nonzero huv;
  have h_orbit_card : (Finset.card (eisNormSet n)) = 6 * (Finset.card (Finset.image (fun z => Ideal.span {z}) (eisNormSet n))) := by
    have h_orbit_card : (Finset.card (eisNormSet n)) = Finset.sum (Finset.image (fun z => Ideal.span {z}) (eisNormSet n)) (fun I => (Finset.filter (fun w => Ideal.span {w} = I) (eisNormSet n)).card) := by
      rw [ Finset.card_eq_sum_ones, Finset.sum_image' ] ; aesop;
    rw [ h_orbit_card, Finset.sum_const_nat ];
    rw [ mul_comm ];
    aesop;
  convert h_orbit_card using 2;
  refine' Finset.card_bij _ _ _ _;
  use fun I hI => I;
  · simp +zetaDelta at *;
    grind +suggestions;
  · grind;
  · simp +zetaDelta at *;
    intro z hz; rw [ mem_eisNormSet_iff ] at hz; rw [ algebraNorm_eq_norm ] ; aesop;

end Eisenstein