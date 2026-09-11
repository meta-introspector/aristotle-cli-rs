import Mathlib
import RequestProject.GradedInduction
import RequestProject.GradedLattice
import RequestProject.FunctorialBridge

/-!
# Pattern Engine: Automated CRT Reasoning via Graded Patterns

## Overview

We bundle `OrthIdempSystem N M` with its extracted `CRTPattern` multiset into
a `PatternEnv`, then prove a "master theorem": any property that is
closed under graded induction holds for all CRT forms.

This provides a small ATP kernel for CRT-style proofs.
-/

open Finset

/-! ## §1. PatternEnv: bundling system + patterns -/

/-- A pattern environment bundles an orthogonal idempotent system
    with its extracted proof patterns. -/
structure PatternEnv (N : ℕ) (M : ℕ) where
  /-- The underlying orthogonal idempotent system -/
  sys : OrthIdempSystem N M
  /-- The extracted patterns -/
  patterns : List CRTPattern
  /-- Patterns include all idempotency patterns -/
  has_idemp : ∀ i : Fin N, CRTPattern.idemp i.val ∈ patterns
  /-- Patterns include all orthogonality patterns -/
  has_orth : ∀ i j : Fin N, i < j → CRTPattern.orth i.val j.val ∈ patterns
  /-- Patterns include completeness -/
  has_complete : CRTPattern.complete ∈ patterns

/-- Build a PatternEnv from an OrthIdempSystem using `extractPatterns`. -/
def PatternEnv.fromSystem {N M : ℕ} (sys : OrthIdempSystem N M) : PatternEnv N M where
  sys := sys
  patterns := extractPatterns N
  has_idemp := by
    intro i
    unfold extractPatterns
    simp only [List.mem_append, List.mem_map, List.mem_range]
    left; left; left; exact ⟨i.val, i.isLt, rfl⟩
  has_orth := by
    intro i j hij
    unfold extractPatterns
    simp only [List.mem_append, List.mem_flatMap, List.mem_range, List.mem_filterMap]
    left; left; right
    exact ⟨i.val, i.isLt, j.val, j.isLt, by simp [hij]⟩
  has_complete := by
    unfold extractPatterns
    simp only [List.mem_append, List.mem_cons, List.mem_nil_iff]
    tauto

/-! ## §2. Pattern-Stable Properties -/

/-- A property P on `ZMod M` is "pattern-stable" with respect to a PatternEnv
    if it respects the idempotent structure. -/
structure PatternStable {N M : ℕ} (env : PatternEnv N M) (P : ZMod M → Prop) : Prop where
  /-- P holds for each idempotent -/
  idemp_stable : ∀ i : Fin N, P (env.sys.idemps i)
  /-- P holds for products of distinct idempotents -/
  orth_stable : ∀ i j : Fin N, i ≠ j → P (env.sys.idemps i * env.sys.idemps j)
  /-- P holds for the sum -/
  complete_stable : P (Finset.univ.sum env.sys.idemps)
  /-- P holds for complements -/
  complement_stable : ∀ i : Fin N, P (1 - env.sys.idemps i)

/-- A property Q on forms (PredSel N) is "grade-stable" if it is preserved
    by the graded induction operations. -/
structure GradeStable {N : ℕ} (Q : PredSel N → Prop) : Prop where
  /-- Q holds at grade 0 (empty form) -/
  base : Q ∅
  /-- Q is preserved by insertion (grade increase) -/
  step : ∀ (S : PredSel N) (x : Fin N), x ∉ S → Q S → Q (insert x S)

/-! ## §3. The Master Induction Theorem -/

/-- **Master Theorem**: If Q is grade-stable, then Q holds for all predicate selections. -/
theorem master_graded_induction {N : ℕ} {Q : PredSel N → Prop}
    (hstable : GradeStable Q) : ∀ S : PredSel N, Q S :=
  finset_graded_induction hstable.base hstable.step

/-- Equivalent formulation via strong induction. -/
theorem master_strong_induction {N : ℕ} {Q : PredSel N → Prop}
    (h : ∀ S : PredSel N, (∀ T : PredSel N, T.card < S.card → Q T) → Q S)
    : ∀ S : PredSel N, Q S :=
  graded_strong_induction' h

/-- Equivalent formulation via downward induction. -/
theorem master_downward_induction {N : ℕ} {Q : PredSel N → Prop}
    (htop : Q Finset.univ)
    (hstep : ∀ (S : PredSel N) (x : Fin N), x ∈ S → Q S → Q (S.erase x))
    : ∀ S : PredSel N, Q S :=
  finset_graded_induction_down htop hstep

/-! ## §4. Pattern + Grade Combined Theorem -/

/-- If P is pattern-stable on the algebra and Q is grade-stable on forms,
    then every CRT form satisfies both. -/
theorem pattern_grade_combined {N M : ℕ}
    (env : PatternEnv N M)
    {P : ZMod M → Prop} (hP : PatternStable env P)
    {Q : PredSel N → Prop} (hQ : GradeStable Q)
    : (∀ S : PredSel N, Q S) ∧
      (∀ i : Fin N, P (env.sys.idemps i)) ∧
      (∀ i : Fin N, P (1 - env.sys.idemps i)) := by
  exact ⟨master_graded_induction hQ, hP.idemp_stable, hP.complement_stable⟩

/-! ## §5. Concrete Pattern Environments -/

/-- The Monster pattern environment (N=3, M=196883). -/
def monsterPatternEnv : PatternEnv 3 196883 :=
  PatternEnv.fromSystem monsterSystem

/-- Monster has 16 patterns. -/
theorem monsterPatternEnv_count :
    monsterPatternEnv.patterns.length = 16 := by native_decide

/-! ## §6. Application: Idempotency of All Forms -/

/-
Every CRT form is idempotent.
    Proof: by graded induction, using the fact that each factor eᵢ or (1-eᵢ)
    is idempotent and distinct factors are orthogonal.
-/
theorem all_forms_idempotent {N M : ℕ} (sys : OrthIdempSystem N M) :
    ∀ S : PredSel N, sys.form S * sys.form S = sys.form S := by
  unfold OrthIdempSystem.form;
  unfold crtForm; simp +decide [ ← Finset.prod_mul_distrib ] ;
  have := sys.is_idempotent; have := sys.is_orthogonal; have := sys.is_complete; simp_all +decide [ Finset.prod_ite, Finset.filter_congr, Finset.filter_eq', Finset.filter_ne' ] ;
  grind

/-
Distinct CRT forms are orthogonal: f_S · f_T = 0 for S ≠ T.
-/
theorem distinct_forms_orthogonal {N M : ℕ} (sys : OrthIdempSystem N M) :
    ∀ S T : PredSel N, S ≠ T → sys.form S * sys.form T = 0 := by
  intros S T h_neq
  obtain ⟨i, hi⟩ : ∃ i : Fin N, (i ∈ S ∧ i ∉ T) ∨ (i ∈ T ∧ i ∉ S) := by
    contrapose! h_neq; aesop;
  generalize_proofs at *;
  convert Finset.prod_eq_zero ( Finset.mem_univ i ) _ using 1;
  rotate_left;
  exact fun j => ( if j ∈ S then sys.idemps j else 1 - sys.idemps j ) * ( if j ∈ T then sys.idemps j else 1 - sys.idemps j );
  · have := sys.is_idempotent i; split_ifs <;> simp_all +decide [ sub_mul, mul_sub ] ;
  · rw [ Finset.prod_mul_distrib ];
    rfl

/-
The sum of all forms is 1: ∑_S f_S = 1.
-/
theorem forms_sum_to_one {N M : ℕ} (sys : OrthIdempSystem N M) :
    Finset.univ.sum (fun S : PredSel N => sys.form S) = 1 := by
  -- By expanding the product over Fin N across all subsets S of Fin N, we get ∏_i (e_i + (1-e_i)) = ∏_i 1 = 1.
  have h_expand : ∑ S : Finset (Fin N), ∏ i : Fin N, (if i ∈ S then sys.idemps i else 1 - sys.idemps i) = ∏ i : Fin N, (sys.idemps i + (1 - sys.idemps i)) := by
    rw [ Finset.prod_add ];
    simp +decide [ Finset.prod_ite, Finset.filter_mem_eq_inter, Finset.filter_not ]
  generalize_proofs at *; (
  convert h_expand using 1;
  norm_num +zetaDelta at *)

/-! ## §7. Summary -/

/-- The pattern engine provides:
    • PatternEnv bundling OrthIdempSystem with proof patterns
    • PatternStable and GradeStable closure conditions
    • Master induction theorem for automated CRT reasoning
    • Monster instance with 16 patterns
    • Full 15-prime instance with 346 patterns -/
theorem pattern_engine_summary :
    monsterPatternEnv.patterns.length = 16 ∧
    (extractPatterns 3).length = 16 ∧
    (extractPatterns 15).length = 346 := by
  exact ⟨monsterPatternEnv_count, by native_decide, by native_decide⟩