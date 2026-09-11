/-
# Alternating groups

The alternating group Aₙ is simple for n ≥ 5.
This is one of the fundamental families in the classification
of finite simple groups.

## Atlas data for small alternating groups

| Group | Order      | |Out|  | Schur multiplier |
|-------|------------|--------|------------------|
| A₅    | 60         | 2      | 2                |
| A₆    | 360        | 4      | 6                |
| A₇    | 2520       | 2      | 6                |
| A₈    | 20160      | 2      | 2                |
-/

import Mathlib
import RequestProject.AlternatingSimple

/-! ## Orders of alternating groups -/

/-
The alternating group Aₙ has order n!/2 for n ≥ 2.
-/
theorem alternatingGroup_card_fin (n : ℕ) (hn : 2 ≤ n) :
    Fintype.card (alternatingGroup (Fin n)) = n.factorial / 2 := by
  -- Apply the theorem that states the cardinality of the alternating group is n! / 2.
  have h_card : Fintype.card (alternatingGroup (Fin n)) = Fintype.card (Equiv.Perm (Fin n)) / 2 := by
    have := ( Subgroup.card_mul_index ( alternatingGroup ( Fin n ) ) );
    rw [ Nat.div_eq_of_eq_mul_left ] <;> norm_num at *;
    rw [ ← this, Subgroup.index_eq_two_iff.mpr ];
    refine' ⟨ Equiv.swap ⟨ 0, by linarith ⟩ ⟨ 1, by linarith ⟩, fun b => _ ⟩ ; rcases Int.units_eq_one_or ( Equiv.Perm.sign b ) with h | h <;> simp +decide [ h ];
  simp_all +decide [ Fintype.card_perm ]

/-! ## Simplicity of alternating groups -/

/-- A₅ is simple. This is the smallest non-abelian simple group,
    with order 60. From Mathlib. -/
theorem alternatingGroup_fin5_isSimpleGroup :
    IsSimpleGroup (alternatingGroup (Fin 5)) :=
  alternatingGroup.isSimpleGroup_five

/-- The alternating group Aₙ is simple for n ≥ 5.
    This is a classical result and one of the cornerstones of
    the Atlas of Finite Simple Groups.

    **Status**: Not yet in Mathlib (only A₅ simplicity is proven).
    A full proof would require showing that any nontrivial normal
    subgroup of Aₙ contains a 3-cycle, and hence equals Aₙ by
    `Equiv.Perm.closure_three_cycles_eq_alternating`. -/
theorem alternatingGroup_isSimpleGroup (n : ℕ) (hn : 5 ≤ n) :
    IsSimpleGroup (alternatingGroup (Fin n)) :=
  alternatingGroup_isSimpleGroup' n hn

/-! ## Atlas data: orders of small alternating groups -/

/-
The order of A₅ is 60. (Atlas, p. 2)
-/
theorem alternatingGroup_fin5_card :
    Fintype.card (alternatingGroup (Fin 5)) = 60 := by
  native_decide +revert

/-
The order of A₆ is 360. (Atlas, p. 4)
-/
theorem alternatingGroup_fin6_card :
    Fintype.card (alternatingGroup (Fin 6)) = 360 := by
  convert alternatingGroup_card_fin 6 ( by decide ) using 1

/-
The order of A₇ is 2520. (Atlas, p. 10)
-/
theorem alternatingGroup_fin7_card :
    Fintype.card (alternatingGroup (Fin 7)) = 2520 := by
  convert alternatingGroup_card_fin 7 ( by decide ) using 1

/-
The order of A₈ is 20160. (Atlas, p. 22)
-/
theorem alternatingGroup_fin8_card :
    Fintype.card (alternatingGroup (Fin 8)) = 20160 := by
  convert alternatingGroup_card_fin 8 ( by decide ) using 1