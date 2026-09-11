import Mathlib

/-!
# The Leech lattice `Λ₂₄` — foundational definitions

This file defines the Leech lattice via its Gram matrix (constructed from the
extended binary Golay code, LLL-reduced) and establishes: symmetry, even diagonal,
the LDLᵀ factorization, positive semi-definiteness, and related properties.

## Construction

The Gram matrix was constructed by:
1. Building the extended binary Golay code `C` (a `[24,12,8]` code over `F₂`).
2. Constructing the even Leech lattice `L_int` from `C`.
3. Computing a basis via HNF, then LLL-reducing.
4. Computing `gram = (1/8) · M^T · M` where `M` is the integer basis matrix.
5. Verifying: `det = 1`, symmetric, all diagonal entries even.

The LDLᵀ factorization satisfies `cden • gram = Umatᵀ * diagonal dvec * Umat`.
-/

noncomputable section

open Matrix

namespace Leech

/-! ## Part 0 : Sourced data -/

/-- The Leech lattice Gram matrix (LLL-reduced basis from Golay code construction). -/
def gram : Matrix (Fin 24) (Fin 24) ℤ :=
  !![4, -1, 2, 2, 2, 1, 2, 2, 2, 2, -1, 2, -1, -2, -5, 2, -1, -4, -1, -5, 25, 10, -22, -51;
    -1, 4, 1, 1, 1, -2, 1, 1, 1, 1, 1, 1, -1, 2, -4, -1, -1, -4, 2, -4, 14, 9, -15, -41;
    2, 1, 4, 2, 2, 1, 2, 2, 2, 2, 1, 1, 0, -1, -5, 2, 0, -4, -1, -5, 20, 10, -20, -41;
    2, 1, 2, 4, 2, 1, 2, 2, 2, 2, 1, 2, -1, 0, -4, 1, 0, -5, 1, -4, 19, 10, -17, -47;
    2, 1, 2, 2, 4, 1, 2, 2, 2, 2, 1, 2, -2, -1, -5, 1, 0, -4, 0, -5, 23, 13, -21, -50;
    1, -2, 1, 1, 1, 4, 1, 1, 1, 1, 1, 0, 1, -2, 0, 2, 1, -1, -2, 0, 3, 2, -3, 0;
    2, 1, 2, 2, 2, 1, 4, 2, 2, 2, 1, 2, 0, -1, -6, 2, 0, -5, -1, -6, 23, 12, -23, -54;
    2, 1, 2, 2, 2, 1, 2, 4, 2, 2, 1, 1, -1, 0, -3, 1, 0, -3, 0, -4, 16, 8, -15, -38;
    2, 1, 2, 2, 2, 1, 2, 2, 4, 2, 1, 1, 0, -1, -6, 1, -1, -5, 0, -5, 24, 11, -23, -51;
    2, 1, 2, 2, 2, 1, 2, 2, 2, 4, 1, 1, -1, 0, -4, 2, 0, -4, -1, -4, 21, 10, -20, -44;
    -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, -1, 1, 1, 1, 1, 2, 1, 0, 1, -6, -1, 5, 15;
    2, 1, 1, 2, 2, 0, 2, 1, 1, 1, -1, 4, -2, -1, -5, 0, -2, -5, 1, -4, 23, 12, -21, -55;
    -1, -1, 0, -1, -2, 1, 0, -1, 0, -1, 1, -2, 4, 0, 1, 1, 1, 1, -1, 1, -9, -5, 7, 23;
    -2, 2, -1, 0, -1, -2, -1, 0, -1, 0, 1, -1, 0, 4, 2, -1, 1, 1, 2, 2, -11, -4, 10, 15;
    -5, -4, -5, -4, -5, 0, -6, -3, -6, -4, 1, -5, 1, 2, 20, -3, 4, 17, 0, 18, -77, -38, 75, 177;
    2, -1, 2, 1, 1, 2, 2, 1, 1, 2, 1, 0, 1, -1, -3, 4, 1, -2, -2, -3, 12, 5, -12, -21;
    -1, -1, 0, 0, 0, 1, 0, 0, -1, 0, 2, -2, 1, 1, 4, 1, 4, 4, -1, 3, -19, -8, 18, 43;
    -4, -4, -4, -5, -4, -1, -5, -3, -5, -4, 1, -5, 1, 1, 17, -2, 4, 18, -1, 16, -71, -36, 69, 169;
    -1, 2, -1, 1, 0, -2, -1, 0, 0, -1, 0, 1, -1, 2, 0, -2, -1, -1, 4, 0, 0, 1, 1, -10;
    -5, -4, -5, -4, -5, 0, -6, -4, -5, -4, 1, -4, 1, 2, 18, -3, 3, 16, 0, 20, -75, -37, 73, 176;
    25, 14, 20, 19, 23, 3, 23, 16, 24, 21, -6, 23, -9, -11, -77, 12, -19, -71, 0, -75, 336, 162, -320, -761;
    10, 9, 10, 10, 13, 2, 12, 8, 11, 10, -1, 12, -5, -4, -38, 5, -8, -36, 1, -37, 162, 84, -156, -376;
    -22, -15, -20, -17, -21, -3, -23, -15, -23, -20, 5, -21, 7, 10, 75, -12, 18, 69, 1, 73, -320, -156, 310, 729;
    -51, -41, -41, -47, -50, 0, -54, -38, -51, -44, 15, -55, 23, 15, 177, -21, 43, 169, -10, 176, -761, -376, 729, 1794]

/-- Upper-triangular integer matrix from the denominator-cleared LDLᵀ factorization. -/
def Umat : Matrix (Fin 24) (Fin 24) ℤ :=
  !![1312103520, -328025880, 656051760, 656051760, 656051760, 328025880, 656051760, 656051760, 656051760, 656051760, -328025880, 656051760, -328025880, -656051760, -1640129400, 656051760, -328025880, -1312103520, -328025880, -1640129400, 8200647000, 3280258800, -7216569360, -16729319880;
    0, 1312103520, 524841408, 524841408, 524841408, -612314976, 524841408, 524841408, 524841408, 524841408, 262420704, 524841408, -437367840, 524841408, -1836944928, -174947136, -437367840, -1749471360, 612314976, -1836944928, 7085359008, 4023784128, -7172832576, -18806817120;
    0, 0, 1312103520, 218683920, 218683920, 656051760, 218683920, 218683920, 218683920, 218683920, 656051760, -328025880, 546709800, -328025880, -218683920, 656051760, 546709800, 0, -656051760, -218683920, -328025880, 218683920, -437367840, 3280258800;
    0, 0, 0, 1312103520, 187443360, 562330080, 187443360, 187443360, 187443360, 187443360, 562330080, 281165040, -93721680, 281165040, 374886720, 0, 468608400, -562330080, 562330080, 374886720, -843495120, 187443360, 1312103520, -562330080;
    0, 0, 0, 0, 1312103520, 492038820, 164012940, 164012940, 164012940, 164012940, 492038820, 246019410, -656051760, -328025880, -246019410, 0, 410032350, 82006470, -82006470, -246019410, 1558122930, 1886148810, -1148090580, -2214174690;
    0, 0, 0, 0, 0, 1312103520, 621522720, 621522720, 621522720, 621522720, 207174240, 103587120, 552464640, -414348480, -932284080, 552464640, -379819440, -1622864880, -586993680, -932284080, 5075768880, 2727794160, -5731820640, -11152879920;
    0, 0, 0, 0, 0, 0, 1312103520, -72894640, -72894640, -72894640, 437367840, 218683920, 473815160, -182236600, -583157120, 473815160, 583157120, 36447320, -546709800, -583157120, -364473200, 218683920, -328025880, -692499080;
    0, 0, 0, 0, 0, 0, 0, 1312103520, -77182560, -77182560, 463095360, -463095360, -192956400, 501686640, 1466468640, -192956400, 617460480, 1427877360, 115773840, 771825600, -5248414080, -2547024480, 5209822800, 10381054320;
    0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -82006470, 492038820, -492038820, 492038820, -164012940, -533042055, -205016175, -41003235, 123009705, 123009705, 123009705, 0, -615048525, -41003235, 1968155280;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, 524841408, -524841408, -174947136, 524841408, 830998896, 481104624, 656051760, 830998896, -568578192, 830998896, -2099365632, -1355840304, 2055628848, 6997885440;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -218683920, 656051760, 218683920, 437367840, 656051760, 0, 437367840, 218683920, 437367840, -874735680, -656051760, 1312103520, 4373678400;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -562330080, -187443360, 749773440, -562330080, -562330080, 749773440, 374886720, 1874433600, -2624207040, -1124660160, 2811650400, 7497734400;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, 590446584, -524841408, -65605176, 393631056, -524841408, 426433644, -623249172, 1377708696, 1016880228, -1049682816, -3870705384;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -552464640, 621522720, 414348480, -552464640, 103587120, 379819440, -621522720, 34529040, 276232320, -621522720;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -437367840, 54670980, 273354900, 273354900, -382696860, -601380780, -601380780, 382696860, 437367840;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, 328025880, 656051760, 656051760, -328025880, -656051760, -656051760, 328025880, 656051760;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -145789280, -145789280, -437367840, -145789280, -145789280, 437367840, -583157120;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -211629600, -253955520, -211629600, -211629600, 253955520, -84651840;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -302793120, -252327600, -252327600, 302793120, -100931040;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -328025880, -328025880, 109341960, 437367840;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -437367840, 437367840, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, 656051760, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520, -656051760;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1312103520]

/-- The positive diagonal pivots of the cleared LDLᵀ factorization. -/
def dvec : Fin 24 → ℤ :=
  ![2624207040, 2460194100, 1574524224, 1530787440, 1499546880, 1038748620, 1243045440, 1239208880, 1234920960, 1230097050, 787262112, 765393720, 624811200, 623249172, 414348480, 437367840, 369029115, 282466730, 275118480, 302793120, 246019410, 218683920, 218683920, 164012940]

/-- The global clearing constant. -/
def cden : ℤ := 1129468975386730987567104000

/-! ## Part 1 : Basic Gram-matrix facts -/

/-- The Leech Gram matrix is symmetric. -/
theorem gram_symm : gram.IsSymm := by native_decide

/-- Every diagonal entry of the Leech Gram matrix is even. -/
theorem gram_diag_even (i : Fin 24) : Even (gram i i) := by
  fin_cases i <;> native_decide

/-! ## Part 2 : The LDLᵀ factorization (keystone identity) -/

/-
The factorization identity `cden • gram = Umatᵀ · diagonal dvec · Umat`.
-/
theorem factor : cden • gram = Umatᵀ * (diagonal dvec) * Umat := by
  ext i j; simp +decide [ Matrix.mul_apply ] ;
  revert i j;
  -- By definition of matrix multiplication and the properties of the Gram matrix, we can expand the left-hand side.
  simp [Matrix.diagonal];
  decide +kernel

/-- The clearing constant is positive. -/
theorem cden_pos : 0 < cden := by native_decide

/-- Each LDLᵀ pivot is positive. -/
theorem dvec_pos (j : Fin 24) : 0 < dvec j := by
  fin_cases j <;> native_decide

/-! ## Part 3 : The integer squared-norm function -/

/-- The squared-norm function: `normSq x = ∑_{i,j} gram[i][j] · x[i] · x[j]`. -/
def normSq (x : Fin 24 → ℤ) : ℤ :=
  ∑ i : Fin 24, ∑ j : Fin 24, gram i j * x i * x j

/-- `normSq` as the matrix bilinear pairing. -/
lemma normSq_eq_dotProduct (x : Fin 24 → ℤ) :
    normSq x = x ⬝ᵥ gram.mulVec x := by
  simp only [normSq, dotProduct, Matrix.mulVec, dotProduct]
  congr 1; ext i
  simp only [Finset.mul_sum]
  congr 1; ext j; ring

/-
**Sum-of-squares**: `cden · normSq x = ∑_j dvec j · (Umat *ᵥ x) j ²`.
-/
theorem normSq_sos (x : Fin 24 → ℤ) :
    cden * normSq x = ∑ j : Fin 24, dvec j * (Umat.mulVec x j) ^ 2 := by
  -- By definition of matrix multiplication and the properties of the dot product, we can rewrite the right-hand side of the equation.
  have h_rhs : ∑ j : Fin 24, (dvec j * ((Umat *ᵥ x) j) ^ 2) = x ⬝ᵥ (Umat.transpose * (diagonal dvec) * Umat).mulVec x := by
    -- By definition of matrix multiplication and the dot product, we can rewrite the right-hand side of the equation.
    have h_rhs : x ⬝ᵥ (Umat.transpose * (diagonal dvec) * Umat).mulVec x = (Umat.mulVec x) ⬝ᵥ (diagonal dvec).mulVec (Umat.mulVec x) := by
      simp +decide [ Matrix.mul_assoc, Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec ];
    simp_all +decide [ sq, dotProduct, Matrix.mulVec ];
    simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, diagonal ];
  rw [ h_rhs, ← factor ];
  simp +decide [ normSq_eq_dotProduct, Matrix.mulVec, dotProduct ];
  simp +decide only [Finset.mul_sum _ _ _, mul_assoc, mul_left_comm]

/-- The squared norm is non-negative. -/
theorem normSq_nonneg (x : Fin 24 → ℤ) : 0 ≤ normSq x := by
  have hsos := normSq_sos x
  have hsum : (0 : ℤ) ≤ ∑ j : Fin 24, dvec j * (Umat.mulVec x j) ^ 2 :=
    Finset.sum_nonneg fun j _ =>
      mul_nonneg (le_of_lt (dvec_pos j)) (sq_nonneg _)
  have h : (0 : ℤ) ≤ cden * normSq x := hsos ▸ hsum
  rw [mul_comm] at h
  exact nonneg_of_mul_nonneg_left h cden_pos

/-
**Strict positive definiteness**: `normSq x = 0 ↔ x = 0`.
-/
theorem normSq_eq_zero_iff (x : Fin 24 → ℤ) : normSq x = 0 ↔ x = 0 := by
  constructor
  · intro hx
    have hsos := normSq_sos x
    rw [hx, mul_zero] at hsos
    -- Since each term in the sum is non-negative and their sum is zero, each term must be zero.
    have h_zero_terms : ∀ j, (Umat.mulVec x j) = 0 := by
      exact fun j => sq_eq_zero_iff.mp ( by nlinarith only [ hsos, show 0 < dvec j from dvec_pos j, Finset.single_le_sum ( fun a _ => mul_nonneg ( show 0 ≤ dvec a from by fin_cases a <;> decide ) ( sq_nonneg ( Umat.mulVec x a ) ) ) ( Finset.mem_univ j ) ] );
    have h_det : Umat.det ≠ 0 := by
      have h_det : Umat.det = ∏ j, Umat j j := by
        rw [ Matrix.det_of_upperTriangular ];
        intro i j hij;
        native_decide +revert;
      exact h_det.symm ▸ Finset.prod_ne_zero_iff.mpr fun i _ => by fin_cases i <;> decide;
    exact Matrix.eq_zero_of_mulVec_eq_zero h_det <| funext h_zero_terms
  · rintro rfl; simp [normSq]

/-
The determinant of the Leech Gram matrix is `1` (unimodular).
-/
theorem gram_det : gram.det = 1 := by
  -- From the factorization, we know that `gram` is invertible.
  have h_inv : (Umatᵀ * (diagonal dvec) * Umat).det = cden ^ 24 * gram.det := by
    rw [ ← factor ];
    convert Matrix.det_smul ( gram : Matrix ( Fin 24 ) ( Fin 24 ) ℤ ) cden using 1;
  have h_det_Umat : Umat.det = 1312103520 ^ 24 := by
    erw [ Matrix.det_of_upperTriangular ];
    · native_decide;
    · intro i j hij;
      native_decide +revert;
  simp +zetaDelta at *;
  rw [ h_det_Umat ] at h_inv;
  exact Eq.symm ( by rw [ show cden = 1129468975386730987567104000 by rfl ] at h_inv; exact by rw [ show dvec = ![2624207040, 2460194100, 1574524224, 1530787440, 1499546880, 1038748620, 1243045440, 1239208880, 1234920960, 1230097050, 787262112, 765393720, 624811200, 623249172, 414348480, 437367840, 369029115, 282466730, 275118480, 302793120, 246019410, 218683920, 218683920, 164012940] by rfl ] at h_inv; exact by norm_num [ Fin.prod_univ_succ ] at h_inv; linarith )

/-! ## Part 4 : Theta-series coefficients -/

/-- The Leech theta-series coefficient at level `n`. -/
def theta_coef (n : ℕ) : ℕ :=
  {x : Fin 24 → ℤ | normSq x = (n : ℤ)}.ncard

/-- `Θ_{Λ₂₄}(0) = 1`. -/
theorem theta_coef_zero : theta_coef 0 = 1 := by
  unfold theta_coef
  have h : {x : Fin 24 → ℤ | normSq x = (0 : ℤ)} = {0} := by
    ext x
    simp only [Set.mem_setOf_eq, Set.mem_singleton_iff]
    exact_mod_cast normSq_eq_zero_iff x
  simp only [Nat.cast_zero, h]
  exact Set.ncard_singleton 0

/-- **No roots**: `Λ₂₄` has no norm-2 vectors. -/
theorem leech_no_roots : theta_coef 2 = 0 := by sorry

/-- **Kissing number**: `Λ₂₄` has 196560 minimum-norm vectors. -/
theorem leech_kissing_number : theta_coef 4 = 196560 := by sorry

end Leech