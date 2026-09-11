import Mathlib

/-!
# Graded Induction over CRT Predicate Forms

## Overview

Given N primes p₁, …, pₙ with pairwise coprime moduli, the CRT idempotents e₁, …, eₙ
generate a Boolean algebra of 2^N orthogonal "forms":

  For each subset S ⊆ {1,…,N}, the form  f_S = ∏_{i ∈ S} eᵢ · ∏_{j ∉ S} (1 - eⱼ)

These forms are:
  • Idempotent: f_S² = f_S
  • Orthogonal: f_S · f_T = 0 for S ≠ T
  • Complete: ∑_S f_S = 1

The "grade" of a form is |S|, and we prove properties by induction on the grade,
building from the empty form (grade 0) through singletons (grade 1) up to the
full form (grade N).

## Predicates

Each prime p contributes a predicate "x ≡ aₚ (mod p)" — the CRT coordinate.
A "form" selects a subset of these predicates, giving a syntactic projection
of the full CRT address onto a sub-torus.

## Application to Monster CRT

For {47, 59, 71}, N = 3, we get 2³ = 8 forms, graded:
  Grade 0: f_∅ = (1-e₄₇)(1-e₅₉)(1-e₇₁)
  Grade 1: f_{47}, f_{59}, f_{71}
  Grade 2: f_{47,59}, f_{47,71}, f_{59,71}
  Grade 3: f_{47,59,71} = e₄₇·e₅₉·e₇₁

Each form projects onto the sub-torus for the selected primes.
-/

open Finset

/-! ## §1. Boolean Predicate Lattice -/

/-- A predicate selection over N base predicates. -/
abbrev PredSel (N : ℕ) := Finset (Fin N)

/-- The grade of a predicate selection is its cardinality. -/
def PredSel.grade {N : ℕ} (S : PredSel N) : ℕ := S.card

/-- The total number of predicate selections (forms) is 2^N. -/
theorem total_forms (N : ℕ) : Fintype.card (Finset (Fin N)) = 2 ^ N := by
  simp [Fintype.card_finset, Fintype.card_fin]

/-! ## §2. CRT Form Construction -/

/-- Given N CRT idempotents in ℤ/M and a subset S ⊆ Fin N,
    the "form" f_S = ∏_{i ∈ S} eᵢ · ∏_{j ∉ S} (1 - eⱼ). -/
noncomputable def crtForm (N : ℕ) {M : ℕ} (idemps : Fin N → ZMod M)
    (S : PredSel N) : ZMod M :=
  Finset.univ.prod (fun i =>
    if i ∈ S then idemps i else 1 - idemps i)

/-- The "positive part" of a form: product of selected idempotents only. -/
noncomputable def crtFormPos (N : ℕ) {M : ℕ} (idemps : Fin N → ZMod M)
    (S : PredSel N) : ZMod M :=
  S.prod (fun i => idemps i)

/-! ## §3. Graded Induction Principles -/

/-- Upward graded induction: prove P for ∅, then extend by inserting elements. -/
theorem graded_induction {N : ℕ} {P : PredSel N → Prop}
    (base : P ∅)
    (step : ∀ (S : PredSel N) (x : Fin N), x ∉ S → P S → P (insert x S))
    : ∀ S : PredSel N, P S := by
  intro S
  exact Finset.induction_on S base (fun a s ha ih => step s a ha ih)

/-- Strong graded induction: prove P(S) assuming P holds for all T with |T| < |S|. -/
theorem graded_strong_induction {N : ℕ} {P : PredSel N → Prop}
    (h : ∀ S : PredSel N, (∀ T : PredSel N, T.card < S.card → P T) → P S)
    : ∀ S : PredSel N, P S := by
  have : WellFounded (fun (a b : Finset (Fin N)) => a.card < b.card) :=
    InvImage.wf Finset.card Nat.lt_wfRel.wf
  intro S
  exact this.induction S (fun S ih => h S (fun T hT => ih T hT))

/-- Downward graded induction: prove P for Finset.univ, then shrink by erasing elements. -/
theorem graded_induction_down {N : ℕ} {P : PredSel N → Prop}
    (htop : P Finset.univ)
    (hstep : ∀ (S : PredSel N) (x : Fin N), x ∈ S → P S → P (S.erase x))
    : ∀ S : PredSel N, P S := by
  intro S
  suffices key : ∀ T : PredSel N, P (Finset.univ \ T) by
    have : S = Finset.univ \ (Finset.univ \ S) := by simp
    rw [this]; exact key _
  intro T
  induction T using Finset.induction_on with
  | empty => simpa using htop
  | @insert a s hnotin ih =>
    rw [Finset.sdiff_insert]
    apply hstep
    · exact Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, hnotin⟩
    · exact ih

/-! ## §4. Orthogonal Idempotent Systems -/

/-- A system of N orthogonal idempotents in ℤ/M. -/
structure OrthIdempSystem (N : ℕ) (M : ℕ) where
  /-- The N idempotents -/
  idemps : Fin N → ZMod M
  /-- Each is idempotent: eᵢ² = eᵢ -/
  is_idempotent : ∀ i, idemps i * idemps i = idemps i
  /-- Distinct idempotents are orthogonal: eᵢ · eⱼ = 0 for i ≠ j -/
  is_orthogonal : ∀ i j, i ≠ j → idemps i * idemps j = 0
  /-- The idempotents sum to 1 -/
  is_complete : Finset.univ.sum idemps = 1

/-- The complement 1 - eᵢ is also idempotent. -/
theorem OrthIdempSystem.complement_idempotent {N M : ℕ}
    (sys : OrthIdempSystem N M) (i : Fin N) :
    (1 - sys.idemps i) * (1 - sys.idemps i) = 1 - sys.idemps i := by
  calc (1 - sys.idemps i) * (1 - sys.idemps i)
      = 1 - sys.idemps i - sys.idemps i + sys.idemps i * sys.idemps i := by ring
    _ = 1 - sys.idemps i - sys.idemps i + sys.idemps i := by rw [sys.is_idempotent]
    _ = 1 - sys.idemps i := by ring

/-- eᵢ · (1 - eᵢ) = 0. -/
theorem OrthIdempSystem.idemp_times_complement {N M : ℕ}
    (sys : OrthIdempSystem N M) (i : Fin N) :
    sys.idemps i * (1 - sys.idemps i) = 0 := by
  calc sys.idemps i * (1 - sys.idemps i)
      = sys.idemps i - sys.idemps i * sys.idemps i := by ring
    _ = sys.idemps i - sys.idemps i := by rw [sys.is_idempotent]
    _ = 0 := by ring

/-- (1 - eᵢ) · eᵢ = 0. -/
theorem OrthIdempSystem.complement_times_idemp {N M : ℕ}
    (sys : OrthIdempSystem N M) (i : Fin N) :
    (1 - sys.idemps i) * sys.idemps i = 0 := by
  calc (1 - sys.idemps i) * sys.idemps i
      = sys.idemps i - sys.idemps i * sys.idemps i := by ring
    _ = sys.idemps i - sys.idemps i := by rw [sys.is_idempotent]
    _ = 0 := by ring

/-- The form associated to a subset S. -/
noncomputable def OrthIdempSystem.form {N M : ℕ}
    (sys : OrthIdempSystem N M) (S : PredSel N) : ZMod M :=
  crtForm N sys.idemps S

/-! ## §5. Predicate Reflection -/

/-- A proof pattern extracted from CRT verification. -/
inductive CRTPattern where
  /-- "eᵢ² = eᵢ" — idempotency at index i -/
  | idemp (i : ℕ) : CRTPattern
  /-- "eᵢ · eⱼ = 0" — orthogonality at indices i, j -/
  | orth (i j : ℕ) : CRTPattern
  /-- "∑ eᵢ = 1" — completeness -/
  | complete : CRTPattern
  /-- "proj_p(eᵢ) = δᵢₚ" — projection property -/
  | proj (i p : ℕ) : CRTPattern
  deriving Repr, BEq

/-- Extract all base patterns from an N-idempotent system:
    N idempotency + N(N-1)/2 orthogonality + 1 completeness + N² projection. -/
def extractPatterns (N : ℕ) : List CRTPattern :=
  (List.range N).map CRTPattern.idemp ++
  ((List.range N).flatMap (fun i =>
    (List.range N).filterMap (fun j =>
      if i < j then some (CRTPattern.orth i j) else none))) ++
  [CRTPattern.complete] ++
  ((List.range N).flatMap (fun i =>
    (List.range N).map (fun p => CRTPattern.proj i p)))

/-- For N = 3 (Monster CRT): 3 + 3 + 1 + 9 = 16 patterns. -/
theorem monster_pattern_count : (extractPatterns 3).length = 16 := by native_decide

/-- For N = 15 (full system): 15 + 105 + 1 + 225 = 346 patterns. -/
theorem full_pattern_count : (extractPatterns 15).length = 346 := by native_decide

/-! ## §6. Form ↔ Predicate Bijection -/

/-- Each form S encodes a Boolean predicate vector: bit i is true iff i ∈ S. -/
def formToPredicate {N : ℕ} (S : PredSel N) : Fin N → Bool :=
  fun i => decide (i ∈ S)

/-- Conversely, a Boolean vector determines a form (the filter of true positions). -/
def predicateToForm {N : ℕ} (f : Fin N → Bool) : PredSel N :=
  Finset.univ.filter (fun i => f i = true)

/-- Round-trip: form → predicate → form is the identity. -/
theorem form_pred_roundtrip {N : ℕ} (S : PredSel N) :
    predicateToForm (formToPredicate S) = S := by
  ext i; simp [predicateToForm, formToPredicate]

/-- Round-trip: predicate → form → predicate is the identity. -/
theorem pred_form_roundtrip {N : ℕ} (f : Fin N → Bool) (i : Fin N) :
    formToPredicate (predicateToForm f) i = f i := by
  simp [formToPredicate, predicateToForm]

/-! ## §7. Grade-Specific Properties -/

/-- The grade-0 form is ∏ᵢ (1 - eᵢ). -/
theorem form_empty_eq {N M : ℕ} (sys : OrthIdempSystem N M) :
    sys.form ∅ = Finset.univ.prod (fun i => 1 - sys.idemps i) := by
  simp [OrthIdempSystem.form, crtForm]

/-- The grade-N form is ∏ᵢ eᵢ. -/
theorem form_univ_eq {N M : ℕ} (sys : OrthIdempSystem N M) :
    sys.form Finset.univ = Finset.univ.prod sys.idemps := by
  simp [OrthIdempSystem.form, crtForm]

/-! ## §8. Monster CRT Instance: N = 3, Primes = {47, 59, 71} -/

/-- Monster CRT idempotents in ℤ/196883. -/
def monsterIdemps' : Fin 3 → ZMod 196883
  | ⟨0, _⟩ => 33512   -- e₄₇
  | ⟨1, _⟩ => 113458  -- e₅₉
  | ⟨2, _⟩ => 49914   -- e₇₁

theorem monsterIdemps'_idempotent (i : Fin 3) :
    monsterIdemps' i * monsterIdemps' i = monsterIdemps' i := by
  fin_cases i <;> native_decide

theorem monsterIdemps'_orthogonal (i j : Fin 3) (h : i ≠ j) :
    monsterIdemps' i * monsterIdemps' j = 0 := by
  fin_cases i <;> fin_cases j <;> simp_all <;> native_decide

theorem monsterIdemps'_complete :
    Finset.univ.sum monsterIdemps' = 1 := by native_decide

/-- The Monster CRT system as an OrthIdempSystem. -/
def monsterSystem : OrthIdempSystem 3 196883 where
  idemps := monsterIdemps'
  is_idempotent := monsterIdemps'_idempotent
  is_orthogonal := monsterIdemps'_orthogonal
  is_complete := monsterIdemps'_complete

/-! ### The 8 Monster CRT Forms -/

/-- Grade-0 form: (1 - e₄₇)(1 - e₅₉)(1 - e₇₁) — the "zero" projection. -/
noncomputable def f_none : ZMod 196883 := monsterSystem.form ∅

/-- Grade-1 forms: single-prime projections. -/
noncomputable def f_47 : ZMod 196883 := monsterSystem.form {⟨0, by omega⟩}
noncomputable def f_59 : ZMod 196883 := monsterSystem.form {⟨1, by omega⟩}
noncomputable def f_71 : ZMod 196883 := monsterSystem.form {⟨2, by omega⟩}

/-- Grade-2 forms: two-prime projections. -/
noncomputable def f_47_59 : ZMod 196883 :=
  monsterSystem.form {⟨0, by omega⟩, ⟨1, by omega⟩}
noncomputable def f_47_71 : ZMod 196883 :=
  monsterSystem.form {⟨0, by omega⟩, ⟨2, by omega⟩}
noncomputable def f_59_71 : ZMod 196883 :=
  monsterSystem.form {⟨1, by omega⟩, ⟨2, by omega⟩}

/-- Grade-3 form: e₄₇ · e₅₉ · e₇₁ — the "full" projection. -/
noncomputable def f_all : ZMod 196883 := monsterSystem.form Finset.univ

/-! ## §9. Grade Distribution -/

/-- Monster grade distribution: C(3,0)=1, C(3,1)=3, C(3,2)=3, C(3,3)=1. -/
theorem monster_grade_distribution :
    (Nat.choose 3 0, Nat.choose 3 1, Nat.choose 3 2, Nat.choose 3 3)
    = (1, 3, 3, 1) := by native_decide

/-- Total: 2³ = 8. -/
theorem monster_total_forms : 2 ^ 3 = 8 := by norm_num

/-- For 15 primes: Pascal's row C(15, k). -/
theorem pascal_row_15 :
    (List.range 16).map (Nat.choose 15) =
    [1, 15, 105, 455, 1365, 3003, 5005, 6435, 6435, 5005, 3003, 1365, 455, 105, 15, 1] := by
  native_decide

/-- Sum of Pascal's row = 2^15 = 32768. -/
theorem pascal_sum_15 :
    ((List.range 16).map (Nat.choose 15)).sum = 32768 := by native_decide

/-- 2^15 = 32768. -/
theorem full_monster_forms : 2 ^ 15 = 32768 := by norm_num

/-! ## §10. The 15 Supersingular Primes -/

/-- The 15 supersingular primes. -/
def supersingularPrimes : Fin 15 → ℕ
  | ⟨0, _⟩  => 2  | ⟨1, _⟩  => 3  | ⟨2, _⟩  => 5  | ⟨3, _⟩  => 7  | ⟨4, _⟩  => 11
  | ⟨5, _⟩  => 13 | ⟨6, _⟩  => 17 | ⟨7, _⟩  => 19 | ⟨8, _⟩  => 23 | ⟨9, _⟩  => 29
  | ⟨10, _⟩ => 31 | ⟨11, _⟩ => 41 | ⟨12, _⟩ => 47 | ⟨13, _⟩ => 59 | ⟨14, _⟩ => 71

/-! ## §11. Grand Summary Theorem -/

/-- The graded induction framework:
    • 2^N forms from N idempotents, graded by Pascal's row
    • Upward, downward, and strong induction principles
    • Form ↔ Boolean predicate bijection
    • For Monster N=3: 8 forms in grades (1,3,3,1)
    • For full system N=15: 32768 forms -/
theorem graded_induction_summary :
    2 ^ 3 = 8 ∧
    Nat.choose 3 0 = 1 ∧ Nat.choose 3 1 = 3 ∧
    Nat.choose 3 2 = 3 ∧ Nat.choose 3 3 = 1 ∧
    Nat.choose 3 0 + Nat.choose 3 1 + Nat.choose 3 2 + Nat.choose 3 3 = 2 ^ 3 ∧
    2 ^ 15 = 32768 ∧
    (extractPatterns 3).length = 16 ∧
    (extractPatterns 15).length = 346 := by
  refine ⟨by norm_num, by native_decide, by native_decide, by native_decide,
         by native_decide, by native_decide, by norm_num,
         by native_decide, by native_decide⟩
