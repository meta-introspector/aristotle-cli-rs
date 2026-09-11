/-
  Pca.lean — principal component analysis of the solutions of the different
  systems, and the exact diagonalisation it produces.

  The project now contains several *systems*, each of which has solved
  something on the same thirteen strands:

  * the **conformal system** — the scale factors solving the conformal field
    (`seed`, from `ConformalEmbedding.lean`);
  * the **alife system** — the equilibrium the life grows to from that seed
    (`mature`, from `AlifeLattice.lean`);
  * the **code**, **data**, **proof** and **proof-execution** systems — the
    organisms the life learns from the four translated artifacts
    (`codeLife`, `dataLife`, `proofLife`, `execLife`, from
    `AlifeTranslation.lean`).

  Every solution is a colony, and every value it takes is of the form
  `2 ^ p * 3 ^ q` (`size_factorisation`).  So a solution has two natural
  coordinates: its total 2-content `w2` and its total 3-content `w3`, summed
  over the thirteen strands.  That is the feature map; the six systems become
  six points of the plane, and PCA of those six points is exact rational
  arithmetic followed by a single square root.

  The module has three layers.

  *Generic PCA.*  For a finite list of plane samples: the mean, the centred
  list (whose mean is zero, `sum1_ctr`), the covariance matrix, its symmetry,
  its positive semidefiniteness (`cov_psd`), and trace = total variance.

  *Generic diagonalisation of a symmetric 2×2 matrix.*  `lamP`/`lamM` are the
  two eigenvalues in closed form; they sum to the trace and multiply to the
  determinant, and each satisfies the characteristic equation; `eigBasis` has
  the two eigenvectors as its columns; the columns are orthogonal
  (`axes_orthogonal`); `spectral_eq` is `S · P = P · D`; and `diagonalisation`
  is `P⁻¹ · S · P = D` whenever `P` is invertible.

  *The concrete diagonalisation.*  The six solutions give the covariance matrix

      ⎡ 1543/12   39/2 ⎤
      ⎣   39/2    62/9 ⎦,

  with discriminant `21164377/1296`, which is not a rational square.  The two
  principal variances are located to five decimals, the first principal axis
  explains between 97.16 % and 97.17 % of the variance, and its slope
  `axisSlope` is pinned between `0.156319` and `0.156323`.  That slope is what
  `PcaPlayer.lean` feeds back into the life as a new player.
-/
import Mathlib
import RequestProject.Solfunmeme.Signal.AlifeTranslation

set_option maxRecDepth 100000

namespace Mycelium
namespace Pca

/-! ## Generic PCA for plane samples -/

/-- The number of samples, as a real number. -/
def card (ps : List (ℝ × ℝ)) : ℝ := (ps.length : ℝ)

def sum1 (ps : List (ℝ × ℝ)) : ℝ := (ps.map Prod.fst).sum
def sum2 (ps : List (ℝ × ℝ)) : ℝ := (ps.map Prod.snd).sum

/-- The mean of the first coordinate. -/
noncomputable def mean1 (ps : List (ℝ × ℝ)) : ℝ := sum1 ps / card ps
/-- The mean of the second coordinate. -/
noncomputable def mean2 (ps : List (ℝ × ℝ)) : ℝ := sum2 ps / card ps

/-- The samples, recentred on their mean. -/
noncomputable def ctr (ps : List (ℝ × ℝ)) : List (ℝ × ℝ) :=
  ps.map (fun p => (p.1 - mean1 ps, p.2 - mean2 ps))

/-- Raw second moments of a list of plane points. -/
def sxx (l : List (ℝ × ℝ)) : ℝ := (l.map (fun p => p.1 * p.1)).sum
def sxy (l : List (ℝ × ℝ)) : ℝ := (l.map (fun p => p.1 * p.2)).sum
def syy (l : List (ℝ × ℝ)) : ℝ := (l.map (fun p => p.2 * p.2)).sum

/-- The three entries of the covariance matrix. -/
noncomputable def c11 (ps : List (ℝ × ℝ)) : ℝ := sxx (ctr ps) / card ps
noncomputable def c12 (ps : List (ℝ × ℝ)) : ℝ := sxy (ctr ps) / card ps
noncomputable def c22 (ps : List (ℝ × ℝ)) : ℝ := syy (ctr ps) / card ps

theorem sum_map_sub (l : List (ℝ × ℝ)) (m : ℝ) :
    (l.map (fun p => p.1 - m)).sum = sum1 l - l.length * m := by
  induction l with
  | nil => simp [sum1]
  | cons a t ih => simp [sum1] at ih ⊢; linarith

theorem sum_map_sub' (l : List (ℝ × ℝ)) (m : ℝ) :
    (l.map (fun p => p.2 - m)).sum = sum2 l - l.length * m := by
  induction l with
  | nil => simp [sum2]
  | cons a t ih => simp [sum2] at ih ⊢; linarith

theorem sum1_ctr_eq (ps : List (ℝ × ℝ)) : sum1 (ctr ps) = sum1 ps - ps.length * mean1 ps := by
  rw [ctr, sum1, List.map_map]
  simpa [Function.comp_def] using sum_map_sub ps (mean1 ps)

theorem sum2_ctr_eq (ps : List (ℝ × ℝ)) : sum2 (ctr ps) = sum2 ps - ps.length * mean2 ps := by
  rw [ctr, sum2, List.map_map]
  simpa [Function.comp_def] using sum_map_sub' ps (mean2 ps)

/-- Centring works: the centred samples have mean zero. -/
theorem sum1_ctr {ps : List (ℝ × ℝ)} (h : ps ≠ []) : sum1 (ctr ps) = 0 := by
  have hlen : (ps.length : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (List.length_pos_iff.mpr h).ne'
  rw [sum1_ctr_eq, mean1, card]
  field_simp
  ring

theorem sum2_ctr {ps : List (ℝ × ℝ)} (h : ps ≠ []) : sum2 (ctr ps) = 0 := by
  have hlen : (ps.length : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (List.length_pos_iff.mpr h).ne'
  rw [sum2_ctr_eq, mean2, card]
  field_simp
  ring

/-- The quadratic form of the second moments is the sum of the squares of the
    projections. -/
theorem sum_proj_sq (u v : ℝ) : ∀ l : List (ℝ × ℝ),
    (l.map (fun p => (u * p.1 + v * p.2) ^ 2)).sum
      = u ^ 2 * sxx l + 2 * u * v * sxy l + v ^ 2 * syy l := by
  intro l
  induction l with
  | nil => simp [sxx, sxy, syy]
  | cons a t ih => simp [sxx, sxy, syy] at ih ⊢; nlinarith [ih]

theorem sum_nonneg_of_sq : ∀ (l : List (ℝ × ℝ)) (u v : ℝ),
    0 ≤ (l.map (fun p => (u * p.1 + v * p.2) ^ 2)).sum := by
  intro l
  induction l with
  | nil => intro u v; simp
  | cons a t ih =>
      intro u v
      simp only [List.map_cons, List.sum_cons]
      nlinarith [ih u v, sq_nonneg (u * a.1 + v * a.2)]

/-- **The covariance form is positive semidefinite.** -/
theorem cov_psd {ps : List (ℝ × ℝ)} (h : ps ≠ []) (u v : ℝ) :
    0 ≤ c11 ps * u ^ 2 + 2 * c12 ps * u * v + c22 ps * v ^ 2 := by
  have hlen : (0 : ℝ) < ps.length := by exact_mod_cast List.length_pos_iff.mpr h
  have key := sum_proj_sq u v (ctr ps)
  have hnn := sum_nonneg_of_sq (ctr ps) u v
  rw [key] at hnn
  have hdiv : 0 ≤ (u ^ 2 * sxx (ctr ps) + 2 * u * v * sxy (ctr ps) + v ^ 2 * syy (ctr ps))
      / ps.length := div_nonneg hnn (le_of_lt hlen)
  have hne : (ps.length : ℝ) ≠ 0 := ne_of_gt hlen
  rw [c11, c12, c22, card]
  field_simp at hdiv ⊢
  linarith [hdiv]

/-- The trace of the covariance matrix is the total variance. -/
theorem trace_eq_total_variance (ps : List (ℝ × ℝ)) :
    c11 ps + c22 ps = ((ctr ps).map (fun p => p.1 ^ 2 + p.2 ^ 2)).sum / card ps := by
  have h : ((ctr ps).map (fun p => p.1 ^ 2 + p.2 ^ 2)).sum = sxx (ctr ps) + syy (ctr ps) := by
    induction (ctr ps) with
    | nil => simp [sxx, syy]
    | cons a t ih => simp [sxx, syy] at ih ⊢; nlinarith [ih]
  rw [c11, c22, h, add_div]

/-! ## Diagonalising a symmetric 2×2 matrix, exactly -/

/-- The discriminant of the characteristic polynomial. -/
def disc (a b c : ℝ) : ℝ := (a - c) ^ 2 + 4 * b ^ 2

theorem disc_nonneg (a b c : ℝ) : 0 ≤ disc a b c := by unfold disc; positivity

theorem sq_sqrt_disc (a b c : ℝ) : Real.sqrt (disc a b c) ^ 2 = disc a b c :=
  Real.sq_sqrt (disc_nonneg a b c)

/-- The larger eigenvalue: the first principal variance. -/
noncomputable def lamP (a b c : ℝ) : ℝ := ((a + c) + Real.sqrt (disc a b c)) / 2
/-- The smaller eigenvalue: the second principal variance. -/
noncomputable def lamM (a b c : ℝ) : ℝ := ((a + c) - Real.sqrt (disc a b c)) / 2

/-- The eigenvalues sum to the trace. -/
theorem lam_add (a b c : ℝ) : lamP a b c + lamM a b c = a + c := by rw [lamP, lamM]; ring

/-- The eigenvalues multiply to the determinant. -/
theorem lam_mul (a b c : ℝ) : lamP a b c * lamM a b c = a * c - b ^ 2 := by
  have h : Real.sqrt (disc a b c) ^ 2 = (a - c) ^ 2 + 4 * b ^ 2 := by rw [sq_sqrt_disc]; rfl
  rw [lamP, lamM]
  linear_combination (-1 / 4 : ℝ) * h

theorem lamM_le_lamP (a b c : ℝ) : lamM a b c ≤ lamP a b c := by
  have h : 0 ≤ Real.sqrt (disc a b c) := Real.sqrt_nonneg _
  rw [lamP, lamM]; linarith

theorem lamP_char (a b c : ℝ) : lamP a b c ^ 2 = (a + c) * lamP a b c - (a * c - b ^ 2) := by
  linear_combination lamP a b c * lam_add a b c - lam_mul a b c

theorem lamM_char (a b c : ℝ) : lamM a b c ^ 2 = (a + c) * lamM a b c - (a * c - b ^ 2) := by
  linear_combination lamM a b c * lam_add a b c - lam_mul a b c

/-- The symmetric matrix built from the three covariance entries. -/
def covM (a b c : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![a, b; b, c]

theorem covM_symm (a b c : ℝ) : Matrix.transpose (covM a b c) = covM a b c := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [covM]

/-- The principal axes, as the columns of a matrix. -/
noncomputable def eigBasis (a b c : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![b, b; lamP a b c - a, lamM a b c - a]

/-- The diagonal matrix of principal variances. -/
noncomputable def diagM (a b c : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![lamP a b c, 0; 0, lamM a b c]

/-- **The principal axes are orthogonal.** -/
theorem axes_orthogonal (a b c : ℝ) : b * b + (lamP a b c - a) * (lamM a b c - a) = 0 := by
  linear_combination lam_mul a b c - a * lam_add a b c

/-- **`S · P = P · D`**: the columns of `eigBasis` are eigenvectors of the
    covariance matrix, with the two principal variances as eigenvalues. -/
theorem spectral_eq (a b c : ℝ) :
    covM a b c * eigBasis a b c = eigBasis a b c * diagM a b c := by
  have hP := lamP_char a b c
  have hM := lamM_char a b c
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [covM, eigBasis, diagM, Matrix.mul_apply, Fin.sum_univ_two] <;>
    first
      | ring1
      | linear_combination -hP
      | linear_combination -hM

theorem eigBasis_det (a b c : ℝ) :
    (eigBasis a b c).det = b * (lamM a b c - a) - b * (lamP a b c - a) := by
  simp [eigBasis, Matrix.det_fin_two]

/-- **The diagonalisation.**  Whenever the basis of principal axes is
    invertible, it turns the covariance matrix into the diagonal matrix of
    principal variances. -/
theorem diagonalisation (a b c : ℝ) (h : IsUnit (eigBasis a b c).det) :
    (eigBasis a b c)⁻¹ * covM a b c * eigBasis a b c = diagM a b c := by
  rw [Matrix.mul_assoc, spectral_eq, ← Matrix.mul_assoc, Matrix.nonsing_inv_mul _ h,
    Matrix.one_mul]

/-! ## The two coordinates of a solution

Every recorded size is `2 ^ p * 3 ^ q`; `e2` and `e3` read off the exponents,
and `w2`, `w3` total them over the thirteen strands. -/

def e2 : ℕ → ℕ
  | 2 => 1 | 4 => 2 | 6 => 1 | 8 => 3 | 12 => 2 | 24 => 3 | 48 => 4 | 96 => 5
  | 144 => 4 | 192 => 6 | 1152 => 7 | _ => 0

def e3 : ℕ → ℕ
  | 3 => 1 | 6 => 1 | 12 => 1 | 24 => 1 | 48 => 1 | 96 => 1 | 144 => 2 | 192 => 1
  | 1152 => 2 | _ => 0

/-- The exponents really factorise the sizes. -/
theorem size_factorisation : ∀ s ∈ sizes, 2 ^ e2 s * 3 ^ e3 s = s := by decide

/-- The total 2-content of a colony. -/
def w2 (c : Alife.Colony) : ℕ := (allStrands.map (fun x => e2 (c x))).sum
/-- The total 3-content of a colony. -/
def w3 (c : Alife.Colony) : ℕ := (allStrands.map (fun x => e3 (c x))).sum

/-- The feature map: a solution becomes a point of the plane. -/
noncomputable def featPoint (c : Alife.Colony) : ℝ × ℝ := ((w2 c : ℝ), (w3 c : ℝ))

open Alife

theorem w_seed : w2 seed = 38 ∧ w3 seed = 11 := by decide
theorem w_mature : w2 mature = 39 ∧ w3 mature = 11 := by decide
theorem w_codeLife : w2 codeLife = 24 ∧ w3 codeLife = 5 := by decide
theorem w_dataLife : w2 dataLife = 34 ∧ w3 dataLife = 13 := by decide
theorem w_proofLife : w2 proofLife = 12 ∧ w3 proofLife = 8 := by decide
theorem w_execLife : w2 execLife = 12 ∧ w3 execLife = 8 := by decide

/-- **The solutions of the six systems**, as points of the plane. -/
noncomputable def systems : List (ℝ × ℝ) :=
  [featPoint seed, featPoint mature, featPoint codeLife, featPoint dataLife,
   featPoint proofLife, featPoint execLife]

theorem systems_eq :
    systems = [(38, 11), (39, 11), (24, 5), (34, 13), (12, 8), (12, 8)] := by
  simp only [systems, featPoint, w_seed.1, w_seed.2, w_mature.1, w_mature.2, w_codeLife.1,
    w_codeLife.2, w_dataLife.1, w_dataLife.2, w_proofLife.1, w_proofLife.2,
    w_execLife.1, w_execLife.2]
  norm_num

theorem systems_ne_nil : systems ≠ [] := by rw [systems_eq]; simp

/-! ## The concrete principal component analysis -/

theorem mean_systems : mean1 systems = 53 / 2 ∧ mean2 systems = 28 / 3 := by
  constructor
  · norm_num [mean1, sum1, card, systems_eq]
  · norm_num [mean2, sum2, card, systems_eq]

theorem ctr_systems : ctr systems =
    [(38 - 53 / 2, 11 - 28 / 3), (39 - 53 / 2, 11 - 28 / 3), (24 - 53 / 2, 5 - 28 / 3),
     (34 - 53 / 2, 13 - 28 / 3), (12 - 53 / 2, 8 - 28 / 3), (12 - 53 / 2, 8 - 28 / 3)] := by
  rw [ctr, mean_systems.1, mean_systems.2]
  norm_num [systems_eq]

/-- **The covariance matrix of the six solutions.** -/
theorem cov_systems : c11 systems = 1543 / 12 ∧ c12 systems = 39 / 2 ∧ c22 systems = 62 / 9 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [c11, ctr_systems]; norm_num [sxx, card, systems_eq]
  · rw [c12, ctr_systems]; norm_num [sxy, card, systems_eq]
  · rw [c22, ctr_systems]; norm_num [syy, card, systems_eq]

noncomputable def covA : ℝ := 1543 / 12
noncomputable def covB : ℝ := 39 / 2
noncomputable def covC : ℝ := 62 / 9

/-- The first principal variance of the six solutions. -/
noncomputable def lam1 : ℝ := lamP covA covB covC
/-- The second principal variance. -/
noncomputable def lam2 : ℝ := lamM covA covB covC

noncomputable def sqrtDisc : ℝ := Real.sqrt (disc covA covB covC)

theorem disc_systems : disc covA covB covC = 21164377 / 1296 := by
  norm_num [disc, covA, covB, covC]

/-- The discriminant `21164377/1296` is not a rational square; its root is
    located here to four decimal places. -/
theorem sqrtDisc_bounds : (127.7909 : ℝ) < sqrtDisc ∧ sqrtDisc < 127.791 := by
  have h : sqrtDisc = Real.sqrt (21164377 / 1296) := by simp only [sqrtDisc, disc_systems]
  rw [h]
  refine ⟨?_, ?_⟩
  · rw [show ((127.7909 : ℝ)) = Real.sqrt ((127.7909 : ℝ) ^ 2) from
      (Real.sqrt_sq (by norm_num)).symm]
    exact Real.sqrt_lt_sqrt (by positivity) (by norm_num)
  · rw [show ((127.791 : ℝ)) = Real.sqrt ((127.791 : ℝ) ^ 2) from
      (Real.sqrt_sq (by norm_num)).symm]
    exact Real.sqrt_lt_sqrt (by norm_num) (by norm_num)

theorem covAC : covA + covC = 4877 / 36 := by norm_num [covA, covC]

theorem lam1_eq : lam1 = (4877 / 36 + sqrtDisc) / 2 := by
  show ((covA + covC) + sqrtDisc) / 2 = _
  rw [covAC]

theorem lam2_eq : lam2 = (4877 / 36 - sqrtDisc) / 2 := by
  show ((covA + covC) - sqrtDisc) / 2 = _
  rw [covAC]

theorem lam1_bounds : (131.63156 : ℝ) < lam1 ∧ lam1 < 131.63162 := by
  obtain ⟨h1, h2⟩ := sqrtDisc_bounds
  rw [lam1_eq]; constructor <;> linarith

theorem lam2_bounds : (3.84061 : ℝ) < lam2 ∧ lam2 < 3.84067 := by
  obtain ⟨h1, h2⟩ := sqrtDisc_bounds
  rw [lam2_eq]; constructor <;> linarith

theorem lam_sum : lam1 + lam2 = 4877 / 36 := by rw [lam1_eq, lam2_eq]; ring

/-- **The first principal axis explains more than 97 % of the variance** of the
    six solutions. -/
theorem variance_explained :
    0.9716 < lam1 / (lam1 + lam2) ∧ lam1 / (lam1 + lam2) < 0.9717 := by
  rw [lam_sum]
  obtain ⟨h1, h2⟩ := lam1_bounds
  refine ⟨?_, ?_⟩
  · rw [lt_div_iff₀ (by norm_num)]; linarith
  · rw [div_lt_iff₀ (by norm_num)]; linarith

/-- The slope of the first principal axis in the (2-content, 3-content)
    plane. -/
noncomputable def axisSlope : ℝ := (lam1 - covA) / covB

/-- The principal axis is pinned to six decimal places: along it, the solutions
    of the different systems gain about one unit of 3-content for every six and
    a half units of 2-content. -/
theorem axisSlope_bounds : (0.156319 : ℝ) < axisSlope ∧ axisSlope < 0.156323 := by
  obtain ⟨h1, h2⟩ := lam1_bounds
  have hA : covA = 1543 / 12 := rfl
  have hB : covB = 39 / 2 := rfl
  rw [axisSlope, hA, hB]
  refine ⟨?_, ?_⟩
  · rw [lt_div_iff₀ (by norm_num)]; linarith
  · rw [div_lt_iff₀ (by norm_num)]; linarith

/-- The two principal axes are genuinely different directions, so the basis is
    invertible. -/
theorem eigBasis_det_ne_zero : (eigBasis covA covB covC).det ≠ 0 := by
  rw [eigBasis_det]
  show covB * (lam2 - covA) - covB * (lam1 - covA) ≠ 0
  have h1 := lam1_bounds.1
  have h2 := lam2_bounds.2
  have hB : covB = 39 / 2 := rfl
  rw [hB]
  intro h
  nlinarith [h1, h2]

/-- **The diagonalisation of the solutions of the six systems.** -/
theorem systems_diagonalisation :
    (eigBasis covA covB covC)⁻¹ * covM covA covB covC * eigBasis covA covB covC
      = diagM covA covB covC :=
  diagonalisation covA covB covC (Ne.isUnit eigBasis_det_ne_zero)

/-- The diagonalised matrix really carries the covariance of the six systems on
    its diagonal. -/
theorem covM_eq_cov_systems : covM covA covB covC = covM (c11 systems) (c12 systems) (c22 systems) := by
  rw [cov_systems.1, cov_systems.2.1, cov_systems.2.2]
  rfl

/-! ## Axiom audit -/

#print axioms cov_psd
#print axioms trace_eq_total_variance
#print axioms spectral_eq
#print axioms diagonalisation
#print axioms size_factorisation
#print axioms systems_eq
#print axioms cov_systems
#print axioms variance_explained
#print axioms axisSlope_bounds
#print axioms systems_diagonalisation

end Pca
end Mycelium
