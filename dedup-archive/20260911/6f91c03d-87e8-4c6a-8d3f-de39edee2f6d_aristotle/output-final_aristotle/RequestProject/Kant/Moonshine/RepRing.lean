/-
# The representation layer: multiplicity vectors, fusion, and q-series

`196883` is the dimension of *one* irreducible, not a basis.  The basis is
the 194 irreducible characters, and an object's representation datum is a
multiplicity vector

```
V = ∑ᵢ vᵢ [ρᵢ],    vᵢ ∈ ℤ
```

with `dim` the ℤ-linear map `V ↦ ∑ᵢ vᵢ dᵢ`.

**Everything about the tensor product is conditional.**  The fusion
coefficients `N i j k` of the Monster come from its character table, which
neither Lean nor Mathlib has.  So they are carried as an explicit parameter
`FusionData`, and that parameter appears in the statement of every theorem
that uses it — a reader of one theorem sees at once that it holds *for any*
structure satisfying these axioms, and no conditional result can later be
mistaken for a fact about the Monster.

Proved:

* `dim` is additive and ℤ-homogeneous (`dim_add`, `dim_zsmul`);
* `dim (V ⊗ W) = dim V · dim W` for any `FusionData` (`dim_tensor`) — the
  consistency check that ties dimensions to fusion;
* the tensor product is bilinear and, for symmetric fusion, commutative;
* representation-valued q-series with exact convolution, the graded
  dimension of a product (`dimSeries_qmul`), and the truncation
  `R[q]/(q^{N+1})` being closed under it (`trunc_qmul`);
* the moonshine head `1 + 196883 = 196884`, from the degrees of the two
  irreducibles involved carried as hypotheses (`dim_moonshine_head`).
-/
import Mathlib
import RequestProject.Kant.Moonshine.Degrees

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Finset

/-- An element of the representation ring: the multiplicity of each of the
194 irreducibles.  Non-negative vectors are actual representations; general
ones are virtual. -/
abbrev RepVector := IrrepIndex → ℤ

/-- The basis vector `[ρ i]`. -/
def irrep (i : IrrepIndex) : RepVector := fun j => if j = i then 1 else 0

/-- A representation is *actual* when no multiplicity is negative. -/
def RepVector.IsActual (v : RepVector) : Prop := ∀ i, 0 ≤ v i

namespace DegreeTable

variable (T : DegreeTable)

/-- The dimension of a virtual representation. -/
def dim (v : RepVector) : ℤ := ∑ i, v i * (T.degree i : ℤ)

@[simp] theorem dim_zero : T.dim (fun _ => 0) = 0 := by simp [dim]

@[simp] theorem dim_irrep (i : IrrepIndex) : T.dim (irrep i) = (T.degree i : ℤ) := by
  simp [dim, irrep, Finset.sum_ite_eq' Finset.univ i]

theorem dim_add (v w : RepVector) : T.dim (fun i => v i + w i) = T.dim v + T.dim w := by
  simp [dim, add_mul, Finset.sum_add_distrib]

theorem dim_zsmul (c : ℤ) (v : RepVector) : T.dim (fun i => c * v i) = c * T.dim v := by
  simp [dim, Finset.mul_sum, mul_assoc]

/-- An actual representation has non-negative dimension. -/
theorem dim_nonneg {v : RepVector} (h : v.IsActual) : 0 ≤ T.dim v :=
  Finset.sum_nonneg fun i _ => mul_nonneg (h i) (Int.natCast_nonneg _)

end DegreeTable

/-! ## Fusion, as an explicit hypothesis -/

/-- Tensor-product multiplicities for a degree table.  These are *data*: the
Monster's actual values come from its character table, which is not
available here, so every theorem that needs them takes this structure as a
parameter. -/
structure FusionData (T : DegreeTable) where
  /-- `N i j k` is the multiplicity of `ρ k` in `ρ i ⊗ ρ j`. -/
  N : IrrepIndex → IrrepIndex → IrrepIndex → ℕ
  /-- Dimensions multiply: `dᵢ · dⱼ = ∑ₖ N i j k · dₖ`. -/
  dimension_compatible :
    ∀ i j, ∑ k, (N i j k : ℤ) * (T.degree k : ℤ) = (T.degree i : ℤ) * (T.degree j : ℤ)

namespace FusionData

variable {T : DegreeTable} (F : FusionData T)

/-- The tensor product of two virtual representations. -/
def tensor (v w : RepVector) : RepVector :=
  fun k => ∑ i, ∑ j, v i * w j * (F.N i j k : ℤ)

/-- The tensor product is bilinear in its left argument. -/
theorem tensor_add_left (u v w : RepVector) :
    F.tensor (fun i => u i + v i) w = fun k => F.tensor u w k + F.tensor v w k := by
  funext k
  simp only [tensor, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  exact Finset.sum_congr rfl fun j _ => by ring

/-- …and in its right argument. -/
theorem tensor_add_right (u v w : RepVector) :
    F.tensor u (fun i => v i + w i) = fun k => F.tensor u v k + F.tensor u w k := by
  funext k
  simp only [tensor, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  exact Finset.sum_congr rfl fun j _ => by ring

/-- **Dimensions multiply.**  For any fusion structure at all, the dimension
of a tensor product is the product of the dimensions — the consistency check
that a decomposition must satisfy. -/
theorem dim_tensor (v w : RepVector) :
    T.dim (F.tensor v w) = T.dim v * T.dim w := by
  have expand : T.dim (F.tensor v w)
      = ∑ i, ∑ j, v i * w j * ∑ k, (F.N i j k : ℤ) * (T.degree k : ℤ) := by
    simp only [DegreeTable.dim, tensor, Finset.sum_mul, Finset.mul_sum]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [Finset.sum_comm]
    exact Finset.sum_congr rfl fun j _ => Finset.sum_congr rfl fun k _ => by ring
  rw [expand]
  have : ∀ i ∈ (Finset.univ : Finset IrrepIndex),
      ∑ j, v i * w j * ∑ k, (F.N i j k : ℤ) * (T.degree k : ℤ)
        = ∑ j, v i * w j * ((T.degree i : ℤ) * (T.degree j : ℤ)) := by
    intro i _
    exact Finset.sum_congr rfl fun j _ => by rw [F.dimension_compatible]
  rw [Finset.sum_congr rfl this, DegreeTable.dim, DegreeTable.dim, Finset.sum_mul_sum]
  exact Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => by ring

/-- Fusion coefficients are non-negative, so a tensor product of actual
representations is actual. -/
theorem tensor_isActual {v w : RepVector} (hv : v.IsActual) (hw : w.IsActual) :
    (F.tensor v w).IsActual := by
  intro k
  refine Finset.sum_nonneg fun i _ => Finset.sum_nonneg fun j _ => ?_
  exact mul_nonneg (mul_nonneg (hv i) (hw j)) (Int.natCast_nonneg _)

end FusionData

/-! ## Representation-valued q-series -/

/-- A formal q-series with representation coefficients: `V(q) = ∑ₘ Vₘ qᵐ`. -/
abbrev QSeries := ℕ → RepVector

/-- Convolution of q-series, coefficientwise tensor product. -/
def qmul {T : DegreeTable} (F : FusionData T) (V W : QSeries) : QSeries :=
  fun n => fun k => ∑ p ∈ Finset.antidiagonal n, F.tensor (V p.1) (W p.2) k

/-- The graded dimension `Dim(V; q)`, coefficient by coefficient. -/
def dimSeries (T : DegreeTable) (V : QSeries) : ℕ → ℤ := fun n => T.dim (V n)

/-- **The graded dimension of a product is the convolution of the graded
dimensions.** -/
theorem dimSeries_qmul {T : DegreeTable} (F : FusionData T) (V W : QSeries) (n : ℕ) :
    dimSeries T (qmul F V W) n
      = ∑ p ∈ Finset.antidiagonal n, dimSeries T V p.1 * dimSeries T W p.2 := by
  calc dimSeries T (qmul F V W) n
      = ∑ p ∈ Finset.antidiagonal n, T.dim (F.tensor (V p.1) (W p.2)) := by
        simp only [dimSeries, DegreeTable.dim, qmul, Finset.sum_mul]
        rw [Finset.sum_comm]
    _ = ∑ p ∈ Finset.antidiagonal n, dimSeries T V p.1 * dimSeries T W p.2 :=
        Finset.sum_congr rfl fun p _ => F.dim_tensor _ _

/-- Truncation to `R(M)[q]/(q^{N+1})`. -/
def trunc (N : ℕ) (V : QSeries) : QSeries := fun n => if n ≤ N then V n else fun _ => 0

/-- **The truncation is a ring truncation**: multiplying truncated series and
truncating again gives the truncation of the true product, so arithmetic in
`R(M)[q]/(q^{N+1})` is exact. -/
theorem trunc_qmul {T : DegreeTable} (F : FusionData T) (V W : QSeries) (N : ℕ) :
    trunc N (qmul F (trunc N V) (trunc N W)) = trunc N (qmul F V W) := by
  funext n
  by_cases hn : n ≤ N
  · simp only [trunc, if_pos hn]
    funext k
    simp only [qmul]
    refine Finset.sum_congr rfl fun p hp => ?_
    have h1 : p.1 ≤ N := by
      have : p.1 + p.2 = n := (Finset.mem_antidiagonal.mp hp)
      omega
    have h2 : p.2 ≤ N := by
      have : p.1 + p.2 = n := (Finset.mem_antidiagonal.mp hp)
      omega
    simp [trunc, if_pos h1, if_pos h2]
  · simp [trunc, if_neg hn]

/-! ## The moonshine head, from hypotheses -/

/-- If the table gives the trivial representation dimension `1` and another
irreducible dimension `196883`, then their sum has dimension `196884` — the
first non-trivial coefficient of the normalized `J`-function.  Both degrees
are hypotheses: no character table is claimed here. -/
theorem dim_moonshine_head {T : DegreeTable} {i j : IrrepIndex}
    (hi : T.degree i = 1) (hj : T.degree j = 196883) :
    T.dim (fun k => irrep i k + irrep j k) = 196884 := by
  rw [T.dim_add, T.dim_irrep, T.dim_irrep, hi, hj]
  norm_num

end Kant.Moonshine
