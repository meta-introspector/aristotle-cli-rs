/-
# The complexity lattice: finite-group nodes and their capacity

Nodes of the lattice are finite groups; the `capacity` of a node is its order,
and the order relation is group division (here: embedding via an injective
homomorphism), which is monotone for capacity (`capacity_le_of_injective`).

`isAt G n` records that node `G` sits at capacity `n`. Concrete nodes catalogued
here are the ones that show up as Krohn-Rhodes components of the recognizers in
`RequestProject/Recognizers/`:

| node      | group                     | capacity |
|-----------|---------------------------|----------|
| `gpZ2`    | `ZMod 2` (multiplicative) | 2        |
| `gpA5`    | `A₅`                      | 60       |
| `gpSL23`  | `SL(2, F₃)`               | 24       |
| `gpSL27`  | `SL(2, F₇)`               | 336      |

All four capacities are *proved* here (`isAt_gpZ2`, `isAt_gpA5`, `isAt_gpSL23`,
`isAt_gpSL27`), not cited as constants.
-/
import Mathlib

namespace ComplexityLattice

open Equiv

/-- The capacity of a lattice node: the order of the finite group. -/
noncomputable def capacity (G : Type*) [Group G] : ℕ := Nat.card G

/-- `G` sits at capacity `n` on the lattice. -/
def isAt (G : Type*) [Group G] (n : ℕ) : Prop := capacity G = n

/-- Capacity is monotone along embeddings of groups: this is the only lattice
machinery needed to *place* a group that has been identified as a component of
some recognizer's decomposition. -/
theorem capacity_le_of_injective {G H : Type*} [Group G] [Group H] [Finite H] (f : G →* H)
    (hf : Function.Injective f) : capacity G ≤ capacity H :=
  Nat.card_le_card_of_injective f hf

/-- Isomorphic groups sit at the same lattice node. -/
theorem capacity_eq_of_mulEquiv {G H : Type*} [Group G] [Group H] (e : G ≃* H) :
    capacity G = capacity H :=
  Nat.card_congr e.toEquiv

/-- Sandwiching: if a node of capacity `n` embeds into `H`, then `H` has capacity
at least `n`. -/
theorem le_capacity_of_isAt {G H : Type*} [Group G] [Group H] [Finite H] {n : ℕ}
    (hG : isAt G n) (f : G →* H) (hf : Function.Injective f) : n ≤ capacity H := by
  rw [← hG]; exact capacity_le_of_injective f hf

/-! ## Catalogued nodes -/

/-- The two-element cyclic group: the smallest nontrivial node, the group behind
parity/modular counting. -/
abbrev gpZ2 : Type := Multiplicative (ZMod 2)

/-- The alternating group `A₅`, the smallest nonabelian simple group. -/
abbrev gpA5 : Type := alternatingGroup (Fin 5)

/-- `SL(2, F₃)`. -/
abbrev gpSL23 : Type := Matrix.SpecialLinearGroup (Fin 2) (ZMod 3)

/-- `SL(2, F₇)`. -/
abbrev gpSL27 : Type := Matrix.SpecialLinearGroup (Fin 2) (ZMod 7)

theorem isAt_gpZ2 : isAt gpZ2 2 := by
  simp [isAt, capacity, Nat.card_eq_fintype_card]

theorem isAt_gpA5 : isAt gpA5 60 := by
  have h : 2 * Nat.card gpA5 = Nat.card (Equiv.Perm (Fin 5)) := by
    simp only [Nat.card_eq_fintype_card]
    exact two_mul_card_alternatingGroup
  have h120 : Nat.card (Equiv.Perm (Fin 5)) = 120 := by
    simp [Nat.card_eq_fintype_card, Fintype.card_perm, Nat.factorial]
  rw [isAt, capacity]
  omega

set_option maxRecDepth 100000 in
theorem isAt_gpSL23 : isAt gpSL23 24 := by
  rw [isAt, capacity, Nat.card_eq_fintype_card]
  decide

set_option maxRecDepth 1000000 in
set_option maxHeartbeats 2000000 in
theorem isAt_gpSL27 : isAt gpSL27 336 := by
  rw [isAt, capacity, Nat.card_eq_fintype_card]
  decide

end ComplexityLattice
