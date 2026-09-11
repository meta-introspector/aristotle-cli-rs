import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root

/-!
# Eisenstein integers as a free ℤ-module; the algebra norm

This file establishes the bridge between our concrete `Eisenstein.norm` and
Mathlib's `Algebra.norm ℤ` and `Ideal.absNorm`.
-/

noncomputable section

open scoped Classical

namespace Eisenstein

/-! ## The standard ℤ-basis (1, ω) -/

/-- The standard ℤ-basis of `Eisenstein`: `basisFun 0 = 1`, `basisFun 1 = ω`. -/
def basisFun : Fin 2 → Eisenstein
  | 0 => 1
  | 1 => ⟨0, 1⟩

/-
Helper: integer cast into Eisenstein.
-/
theorem intCast_eq (n : ℤ) : (n : Eisenstein) = ⟨n, 0⟩ := by
  induction n using Int.induction_on <;> aesop

/-
Helper: zsmul on Eisenstein.
-/
theorem zsmul_eq (n : ℤ) (z : Eisenstein) : n • z = ⟨n * z.a, n * z.b⟩ := by
  induction n using Int.induction_on <;> simp_all +decide [ mul_add, add_mul, zsmul_eq_mul ];
  · rfl;
  · simp_all +decide [ mul_comm, mul_left_comm, sub_eq_add_neg, add_mul, mul_add, add_assoc ];
    rfl

/-- A linear combination `c 0 · 1 + c 1 · ω` is just `⟨c 0, c 1⟩`. -/
theorem basisFun_lc (c : Fin 2 → ℤ) :
    (∑ i, c i • basisFun i) = ⟨c 0, c 1⟩ := by
  simp only [Fin.sum_univ_two, basisFun]
  rw [zsmul_eq, zsmul_eq]
  ext <;> simp

/-- Linear independence of `(1, ω)` over `ℤ`. -/
theorem basisFun_linearIndependent : LinearIndependent ℤ basisFun := by
  rw [Fintype.linearIndependent_iff]
  intro c hc
  rw [basisFun_lc] at hc
  intro i
  fin_cases i
  · exact_mod_cast congr_arg Eisenstein.a hc
  · exact_mod_cast congr_arg Eisenstein.b hc

/-- The basis spans all of `Eisenstein`. -/
theorem basisFun_spans : ⊤ ≤ Submodule.span ℤ (Set.range basisFun) := by
  intro z _
  have hz_eq : z = z.a • basisFun 0 + z.b • basisFun 1 := by
    rw [zsmul_eq, zsmul_eq]
    ext <;> simp [basisFun]
  rw [hz_eq]
  exact Submodule.add_mem _ (Submodule.smul_mem _ _ (Submodule.subset_span ⟨0, rfl⟩))
    (Submodule.smul_mem _ _ (Submodule.subset_span ⟨1, rfl⟩))

/-- The standard basis of `Eisenstein` as a `Module.Basis`. -/
def eisensteinBasis : Module.Basis (Fin 2) ℤ Eisenstein :=
  Module.Basis.mk basisFun_linearIndependent basisFun_spans

@[simp] theorem eisensteinBasis_zero : eisensteinBasis 0 = 1 :=
  Module.Basis.mk_apply basisFun_linearIndependent basisFun_spans 0

@[simp] theorem eisensteinBasis_one : eisensteinBasis 1 = ⟨0, 1⟩ :=
  Module.Basis.mk_apply basisFun_linearIndependent basisFun_spans 1

/-! ## Module.Free / Module.Finite instances -/

instance : Module.Free ℤ Eisenstein := Module.Free.of_basis eisensteinBasis

instance : Module.Finite ℤ Eisenstein := Module.Finite.of_basis eisensteinBasis

/-! ## CharZero instance -/

instance : CharZero Eisenstein := by
  constructor
  intro m n h
  have : (m : ℤ) = (n : ℤ) := by
    have h1 : ((m : ℤ) : Eisenstein) = ((n : ℤ) : Eisenstein) := by exact_mod_cast h
    have h2 : ((m : ℤ) : Eisenstein).a = ((n : ℤ) : Eisenstein).a := congr_arg Eisenstein.a h1
    rw [intCast_eq, intCast_eq] at h2
    exact h2
  exact_mod_cast this

/-! ## Algebra.norm agrees with our norm -/

/-
The repr of an Eisenstein integer in the standard basis.
-/
theorem eisensteinBasis_repr (z : Eisenstein) :
    eisensteinBasis.repr z = Finsupp.equivFunOnFinite.invFun (fun i => if i = 0 then z.a else z.b) := by
  -- By definition of $eisensteinBasis$, we know that $z = \sum_{i=0}^{1} c_i e_i$ where $c_i$ are the coefficients.
  have h_decomp : z = ∑ i, (eisensteinBasis.repr z i) • eisensteinBasis i := by
    conv_lhs => rw [ ← eisensteinBasis.sum_repr z ] ;
  convert h_decomp using 1;
  constructor <;> intro h <;> simp +decide [ Finsupp.ext_iff, Fin.forall_fin_two ] at *;
  · exact h_decomp;
  · convert congr_arg ( fun x : Eisenstein => ( x.a, x.b ) ) h.symm using 1 ; simp +decide ;
    erw [ intCast_eq, intCast_eq ] ; simp +decide ;

/-
The Eisenstein-integer field norm equals `Algebra.norm ℤ`.
-/
theorem algebraNorm_eq_norm (z : Eisenstein) :
    Algebra.norm ℤ z = norm z := by
  -- By definition of `Algebra.norm`, we know that `Algebra.norm z` is the determinant of the linear map `mul z`.
  have h_det : (Algebra.norm ℤ z) = Matrix.det (LinearMap.toMatrix eisensteinBasis eisensteinBasis (LinearMap.mul ℤ Eisenstein z)) := by
    convert ( Algebra.norm_eq_matrix_det ( R := ℤ ) ( S := Eisenstein ) eisensteinBasis z );
  rw [ h_det, Matrix.det_fin_two ];
  simp +decide [ LinearMap.toMatrix_apply ];
  rw [ eisensteinBasis_repr, eisensteinBasis_repr ] ; simp +decide [ Finsupp.equivFunOnFinite ] ; ring_nf;
  unfold Eisenstein.norm; ring;

/-! ## Bridge to Ideal.absNorm -/

/-- The absolute norm of a principal ideal `(z)` equals `|norm z|`. -/
theorem absNorm_span_singleton (z : Eisenstein) :
    Ideal.absNorm (Ideal.span {z} : Ideal Eisenstein) = (norm z).natAbs := by
  rw [Ideal.absNorm_span_singleton, algebraNorm_eq_norm]

/-- `Ideal.absNorm` is multiplicative on principal ideals. -/
theorem absNorm_span_mul (z w : Eisenstein) :
    Ideal.absNorm ((Ideal.span {z} : Ideal Eisenstein) * Ideal.span {w}) =
      (norm z).natAbs * (norm w).natAbs := by
  rw [_root_.map_mul, absNorm_span_singleton, absNorm_span_singleton]

end Eisenstein