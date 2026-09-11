import Mathlib
import RequestProject.SupersingularPrimes

/-!
# Monster Group Model

We model the Monster group via a typeclass, avoiding an explicit construction
of this enormous group (order ~8×10⁵³). The typeclass encodes the key
group-theoretic invariants: simplicity, exact order, and number of conjugacy classes.
-/

open scoped BigOperators

/-- Typeclass for a type that models the Monster group. -/
class MonsterGroup (M : Type*) [Group M] [Fintype M] [DecidableRel (IsConj (α := M))] where
  /-- The Monster is simple. -/
  isSimple : IsSimpleGroup M
  /-- The Monster has the correct order. -/
  card_eq : Fintype.card M = monsterOrder
  /-- The Monster has exactly 194 conjugacy classes. -/
  conjClasses_card : Fintype.card (ConjClasses M) = numIrreps

/-- The Monster is a simple group (given a model). -/
theorem monster_isSimpleGroup (M : Type*) [Group M] [Fintype M]
    [DecidableRel (IsConj (α := M))] [MonsterGroup M] : IsSimpleGroup M :=
  MonsterGroup.isSimple

/-- The order of the Monster group. -/
theorem monster_card (M : Type*) [Group M] [Fintype M]
    [DecidableRel (IsConj (α := M))] [MonsterGroup M] : Fintype.card M = monsterOrder :=
  MonsterGroup.card_eq

/-- The number of conjugacy classes equals the number of irreducible representations. -/
theorem monster_conjClasses_card (M : Type*) [Group M] [Fintype M]
    [DecidableRel (IsConj (α := M))] [MonsterGroup M] :
    Fintype.card (ConjClasses M) = numIrreps :=
  MonsterGroup.conjClasses_card

/-- Every supersingular prime divides the order of the Monster. -/
theorem ssp_divides_monster_order (M : Type*) [Group M] [Fintype M]
    [DecidableRel (IsConj (α := M))] [MonsterGroup M]
    (p : ℕ) (hp : p ∈ supersingularPrimes) : p ∣ Fintype.card M := by
  rw [monster_card]
  exact ssp_dvd_monsterOrder p hp
