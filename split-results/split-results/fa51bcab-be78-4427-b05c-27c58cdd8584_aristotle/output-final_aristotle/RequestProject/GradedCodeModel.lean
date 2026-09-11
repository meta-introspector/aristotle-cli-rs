/-
GradedCodeModel.lean — A graded-algebra model of a code base.

This file makes precise the idea (from the companion tools `SplitDecls`/`DupFinder`)
of viewing a code base — a collection of declarations together with their dependency
structure — as a *graded algebra*, and of detecting **duplicate** and **similar** code
as algebraic relations inside that model.

## The model

* Atomic declarations are the *variables* of a polynomial algebra `MvPolynomial Decl R`.
* A compound declaration is built by combining atoms multiplicatively; the free
  commutative product of atoms is a monomial `Decl →₀ ℕ`, which we read as the
  declaration's **dependency multiset** (each atom counted with multiplicity).
* Each atom carries a weight `w : Decl → ℕ` — its complexity / depth in the dependency
  DAG — and the algebra is **graded by weighted total degree**. The graded pieces are
  `MvPolynomial.weightedHomogeneousSubmodule R w n`, and Mathlib's
  `MvPolynomial.weightedGradedAlgebra` shows they assemble into a genuine `GradedAlgebra`.

## What is proved

* `codeGradedAlgebra` : the code algebra is a `GradedAlgebra`.
* `declElt_mem_grade` : a declaration sits in the graded piece equal to its grade.
* `declElt_mul` / `declGrade_add` / `code_mul_mem_grade` : composing two pieces of code
  multiplies their algebra elements and *adds* their grades (the graded multiplication law).
* `IsDuplicate` / `IsSimilar` : duplicate code = equal dependency multisets (hence equal
  algebra elements); similar code = equal grade. Both are equivalence relations and
  duplicates refine similars.
* `CodeBase` : a named-declaration layer, with `grade_eq_of_duplicate` and a concrete
  worked example.
-/
import Mathlib

open MvPolynomial

namespace GradedCodeModel

variable {Decl : Type*} {R : Type*} [CommSemiring R]

/-! ## The graded code algebra -/

/-- The grading family of the code algebra: the weighted-homogeneous components of
`MvPolynomial Decl R`, where each atomic declaration `d` has weight `w d`. -/
abbrev codeGrade (w : Decl → ℕ) : ℕ → Submodule R (MvPolynomial Decl R) :=
  weightedHomogeneousSubmodule R w

/-- **The math model of code as a graded algebra.** The polynomial algebra on the atomic
declarations, graded by weighted total degree, is a graded algebra. -/
noncomputable def codeGradedAlgebra (w : Decl → ℕ) :
    GradedAlgebra (codeGrade (R := R) w) :=
  MvPolynomial.weightedGradedAlgebra R w

/-- The algebra element representing a declaration whose dependency multiset is `m`
(a single monomial with unit coefficient). -/
noncomputable def declElt (m : Decl →₀ ℕ) : MvPolynomial Decl R := monomial m 1

/-- The grade (weighted total degree) of a declaration with dependency multiset `m`. -/
noncomputable def declGrade (w : Decl → ℕ) (m : Decl →₀ ℕ) : ℕ := Finsupp.weight w m

/-- A declaration lives in exactly the graded piece named by its grade. -/
theorem declElt_mem_grade (w : Decl → ℕ) (m : Decl →₀ ℕ) :
    declElt (R := R) m ∈ codeGrade (R := R) w (declGrade w m) := by
  rw [codeGrade, declGrade, mem_weightedHomogeneousSubmodule]
  exact isWeightedHomogeneous_monomial _ _ _ rfl

/-- Composing two declarations multiplies their algebra elements: the dependency
multisets add. -/
theorem declElt_mul (m₁ m₂ : Decl →₀ ℕ) :
    declElt (R := R) m₁ * declElt (R := R) m₂ = declElt (m₁ + m₂) := by
  rw [declElt, declElt, declElt, monomial_mul, mul_one]

/-- Grades are additive under composition. -/
theorem declGrade_add (w : Decl → ℕ) (m₁ m₂ : Decl →₀ ℕ) :
    declGrade w (m₁ + m₂) = declGrade w m₁ + declGrade w m₂ := by
  simp [declGrade, map_add]

/-- **The graded multiplication law for code.** A product of a grade-`i` piece and a
grade-`j` piece of code is a grade-`(i + j)` piece. -/
theorem code_mul_mem_grade (w : Decl → ℕ) {i j : ℕ} {a b : MvPolynomial Decl R}
    (ha : a ∈ codeGrade (R := R) w i) (hb : b ∈ codeGrade (R := R) w j) :
    a * b ∈ codeGrade (R := R) w (i + j) := by
  haveI := codeGradedAlgebra (R := R) w
  exact SetLike.mul_mem_graded ha hb

/-! ## Duplicate and similar code -/

/-- **Duplicate code**: two declarations are duplicates when they have the same
dependency multiset (hence the same algebra element). -/
def IsDuplicate (m₁ m₂ : Decl →₀ ℕ) : Prop := m₁ = m₂

/-- **Similar code**: two declarations are similar (for the weighting `w`) when they have
the same grade. This is strictly weaker than being duplicates. -/
noncomputable def IsSimilar (w : Decl → ℕ) (m₁ m₂ : Decl →₀ ℕ) : Prop :=
  declGrade w m₁ = declGrade w m₂

/-- Duplicates have equal algebra elements. -/
theorem declElt_eq_of_isDuplicate {m₁ m₂ : Decl →₀ ℕ} (h : IsDuplicate m₁ m₂) :
    declElt (R := R) m₁ = declElt (R := R) m₂ := by
  rw [IsDuplicate] at h; rw [h]

/-- Duplicates have equal grade. -/
theorem declGrade_eq_of_isDuplicate (w : Decl → ℕ) {m₁ m₂ : Decl →₀ ℕ}
    (h : IsDuplicate m₁ m₂) : declGrade w m₁ = declGrade w m₂ := by
  rw [IsDuplicate] at h; rw [h]

/-- Duplicate code is in particular similar code. -/
theorem isSimilar_of_isDuplicate (w : Decl → ℕ) {m₁ m₂ : Decl →₀ ℕ}
    (h : IsDuplicate m₁ m₂) : IsSimilar w m₁ m₂ :=
  declGrade_eq_of_isDuplicate w h

/-- "Is a duplicate of" is an equivalence relation. -/
theorem isDuplicate_equivalence : Equivalence (@IsDuplicate Decl) := by
  constructor <;> intro <;> simp_all [IsDuplicate]

/-- "Is similar to" is an equivalence relation. -/
theorem isSimilar_equivalence (w : Decl → ℕ) : Equivalence (IsSimilar w) := by
  constructor
  · intro x; rfl
  · intro x y h; exact h.symm
  · intro x y z h1 h2; exact h1.trans h2

/-! ## A named-declaration code base -/

/-- A code base over a set of declaration *names* `Nm`, built from atomic units `Decl`:
a weight on atoms together with the dependency multiset of each named declaration. -/
structure CodeBase (Nm : Type*) (Decl : Type*) where
  /-- complexity / depth weight of each atomic declaration -/
  weight : Decl → ℕ
  /-- dependency multiset of each named declaration -/
  deps : Nm → (Decl →₀ ℕ)

namespace CodeBase

variable {Nm : Type*}

/-- The algebra element of a named declaration. -/
noncomputable def repr (cb : CodeBase Nm Decl) (n : Nm) : MvPolynomial Decl R :=
  declElt (cb.deps n)

/-- The grade of a named declaration. -/
noncomputable def grade (cb : CodeBase Nm Decl) (n : Nm) : ℕ :=
  declGrade cb.weight (cb.deps n)

/-- Two named declarations are duplicates when their dependency multisets agree. -/
def Duplicate (cb : CodeBase Nm Decl) (a b : Nm) : Prop :=
  IsDuplicate (cb.deps a) (cb.deps b)

/-- Each named declaration sits in the graded piece named by its grade. -/
theorem repr_mem_grade (cb : CodeBase Nm Decl) (n : Nm) :
    cb.repr (R := R) n ∈ codeGrade (R := R) cb.weight (cb.grade n) :=
  declElt_mem_grade cb.weight (cb.deps n)

/-- Duplicate named declarations have the same grade. -/
theorem grade_eq_of_duplicate (cb : CodeBase Nm Decl) {a b : Nm}
    (h : cb.Duplicate a b) : cb.grade a = cb.grade b := by
  unfold CodeBase.grade declGrade
  rw [show cb.deps a = cb.deps b from h]

end CodeBase

/-! ## A concrete worked example

Three atoms with weights `1, 2, 3`, and two named declarations `0` and `1` that have the
*same* dependency multiset `{atom₀, atom₂}` — i.e. duplicate code. -/

/-- Example code base: two named declarations built from the same dependencies. -/
noncomputable def example_cb : CodeBase (Fin 2) (Fin 3) where
  weight := ![1, 2, 3]
  deps := ![Finsupp.single 0 1 + Finsupp.single 2 1,
            Finsupp.single 0 1 + Finsupp.single 2 1]

/-- The two named declarations of `example_cb` are detected as duplicates. -/
example : example_cb.Duplicate 0 1 := rfl

/-- Duplicate declarations land in the same grade. -/
example : example_cb.grade 0 = example_cb.grade 1 :=
  example_cb.grade_eq_of_duplicate rfl

end GradedCodeModel
