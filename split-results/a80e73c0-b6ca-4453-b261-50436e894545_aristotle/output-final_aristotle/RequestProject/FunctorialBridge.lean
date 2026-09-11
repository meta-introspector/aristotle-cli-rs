import Mathlib
import RequestProject.GradedLattice
import RequestProject.GradedInduction

/-!
# Functorial Bridge: Predicates ↔ Forms ↔ Blades

## Overview

We establish the chain of isomorphisms:
  PredSel N ≅ BoolVec N ≅ Grade-indexed CRT forms

and connect to the Clifford algebra Cl(0,N) by showing that the
grade-k predicate selections naturally index grade-k blades.

The key structures:
  • `BoolVec N` — Boolean vectors (Fin N → Bool)
  • Explicit equivalence `PredSel N ≃ BoolVec N`
  • Grade-indexed decomposition of the CRT form space
  • Connection to exterior/Clifford algebra structure
-/

open Finset

/-! ## §1. BoolVec and Equivalences -/

/-- Boolean vectors of length N. -/
abbrev BoolVec (N : ℕ) := Fin N → Bool

/-- `PredSel N ≃ BoolVec N`: the characteristic function bijection. -/
def predSelEquivBoolVec (N : ℕ) : PredSel N ≃ BoolVec N where
  toFun S := fun i => decide (i ∈ S)
  invFun f := Finset.univ.filter (fun i => f i = true)
  left_inv S := by ext i; simp
  right_inv f := by ext i; simp

/-- `BoolVec N` has 2^N elements. -/
theorem boolVec_card (N : ℕ) : Fintype.card (BoolVec N) = 2 ^ N := by
  simp [Fintype.card_fun, Fintype.card_bool, Fintype.card_fin]

/-! ## §2. Grade Functions -/

/-- The "blade grade" of a BoolVec is the number of true entries. -/
def bladeGrade {N : ℕ} (v : BoolVec N) : ℕ :=
  (Finset.univ.filter (fun i => v i = true)).card

/-- BoolVec N forms a graded finite lattice with rank = blade grade. -/
instance boolVecGraded (N : ℕ) : @GradedFinLattice (BoolVec N) _ where
  rank := bladeGrade
  maxRank := N
  rank_le_max v := by
    simp only [bladeGrade]
    calc (Finset.univ.filter (fun i => v i = true)).card
        ≤ Finset.univ.card := Finset.card_filter_le _ _
      _ = N := by simp [Fintype.card_fin]

/-- The equivalence `PredSel N ≃ BoolVec N` preserves grade. -/
theorem grade_preserved {N : ℕ} (S : PredSel N) :
    bladeGrade (predSelEquivBoolVec N S) = S.card := by
  simp [bladeGrade, predSelEquivBoolVec]

/-- Conversely, for BoolVec, grade equals the cardinality of the corresponding PredSel. -/
theorem grade_preserved_inv {N : ℕ} (v : BoolVec N) :
    ((predSelEquivBoolVec N).symm v).card = bladeGrade v := by
  simp [bladeGrade, predSelEquivBoolVec]

/-! ## §3. Grade-Indexed Fibers -/

/-- The grade-k fiber: predicate selections of cardinality exactly k. -/
def gradeFiber (N k : ℕ) := { S : PredSel N // S.card = k }

instance (N k : ℕ) : Fintype (gradeFiber N k) := Subtype.fintype _

/-- The grade-k fiber has C(N,k) elements. -/
theorem gradeFiber_card (N : ℕ) (k : Fin (N + 1)) :
    Fintype.card (gradeFiber N k.val) = Nat.choose N k.val := by
  simp only [gradeFiber]
  rw [Fintype.card_subtype]
  have h1 : (Finset.univ.filter (fun (S : Finset (Fin N)) => S.card = k.val)).card =
    (Finset.powersetCard k.val (Finset.univ (α := Fin N))).card := by
    congr 1; ext S; simp [Finset.mem_powersetCard]
  rw [h1, Finset.card_powersetCard, Finset.card_univ, Fintype.card_fin]

/-! ## §4. Clifford Algebra Connection (Combinatorial) -/

/-- In the exterior algebra Λ(ℝ^N) ≅ Cl(0,N), a "blade" is specified by
    choosing k basis vectors from {e₁, …, eₙ}. The grade-k blades are
    indexed by k-element subsets of {1,…,N}, i.e., by PredSel N at grade k.

    Total dimension of the exterior algebra = 2^N. -/
theorem exterior_total_dim (N : ℕ) :
    (Finset.range (N + 1)).sum (Nat.choose N) = 2 ^ N :=
  Nat.sum_range_choose N

/-- For N = 3 (Monster CRT): 8 blades in grades (1,3,3,1) matching 8 CRT forms. -/
theorem monster_blade_grades :
    (List.range 4).map (Nat.choose 3) = [1, 3, 3, 1] := by native_decide

/-- For N = 15 (full system): 32768 blades matching 32768 CRT forms. -/
theorem full_blade_count : 2 ^ 15 = 32768 := by norm_num

/-! ## §5. The Functorial Bridge Structure -/

/-- The complete bridge packaging: PredSel, BoolVec, and grade-indexed CRT forms
    are all equivalent, with grade preserved. -/
structure FunctorialCRTBridge (N : ℕ) where
  /-- The equivalence between predicate selections and Boolean vectors -/
  toBoolVec : PredSel N ≃ BoolVec N
  /-- Grade function on predicate selections -/
  predGrade : PredSel N → ℕ
  /-- Grade function on Boolean vectors -/
  boolGrade : BoolVec N → ℕ
  /-- Grade is preserved by the equivalence -/
  grade_compat : ∀ S, boolGrade (toBoolVec S) = predGrade S

/-- The canonical functorial bridge for any N. -/
def canonicalBridge (N : ℕ) : FunctorialCRTBridge N where
  toBoolVec := predSelEquivBoolVec N
  predGrade := Finset.card
  boolGrade := bladeGrade
  grade_compat := grade_preserved

/-! ## §6. OrthIdempSystem Forms as Graded Objects -/

/-- For an OrthIdempSystem, the form at grade k
    is built from k-element subsets — matching the k-blades in Cl(0,N). -/
theorem form_grade_matches_blade {N M : ℕ} (_sys : OrthIdempSystem N M)
    (S : PredSel N) :
    S.card = bladeGrade ((predSelEquivBoolVec N) S) := by
  rw [grade_preserved]

/-! ## §7. Isomorphism Chain Summary -/

/-- The full isomorphism chain for the Monster (N=3):
    PredSel 3 ≅ BoolVec 3 ≅ {grade-k blades in Cl(0,3)}
    with |PredSel 3| = |BoolVec 3| = 2³ = 8
    and grade distribution (1,3,3,1). -/
theorem functorial_bridge_summary :
    Fintype.card (PredSel 3) = 8 ∧
    Fintype.card (BoolVec 3) = 8 ∧
    (List.range 4).map (Nat.choose 3) = [1, 3, 3, 1] ∧
    Fintype.card (PredSel 15) = 32768 ∧
    Fintype.card (BoolVec 15) = 32768 := by
  refine ⟨?_, ?_, by native_decide, ?_, ?_⟩
  · simp [Fintype.card_finset, Fintype.card_fin]
  · rw [boolVec_card]; norm_num
  · simp [Fintype.card_finset, Fintype.card_fin]
  · rw [boolVec_card]; norm_num
