/-
# The bridge: placing a recognizer's Krohn-Rhodes components on the lattice

Two directions, both proved:

* `KrohnRhodes.node_le_dfaGroupCapacity` — if a catalogued lattice node `G`
  (a finite group of known capacity `n`) is realized as a group of state
  permutations of a recognizer `D`, then `D`'s group capacity is at least `n`.
  This is the placement step: exactly the `isAt` / `capacity_le_of_injective`
  reasoning already used to place group nodes, applied to an automaton.
* `KrohnRhodes.not_groupDivides_of_groupComplexityZero` — a recognizer of group
  complexity `0` admits *no* lattice node of capacity `≥ 2` as a component of
  its decomposition.
-/
import RequestProject.KrohnRhodes.TransitionMonoid
import RequestProject.ComplexityLattice

namespace KrohnRhodes

open ComplexityLattice Function

variable {A Q : Type*}

/-- **Placement.** A lattice node `G` sitting at capacity `n`, realized inside a
recognizer's transition monoid as a group of state permutations, forces the
recognizer's group capacity to be at least `n`. -/
theorem node_le_dfaGroupCapacity [Finite Q] [DecidableEq Q] {G : Type*} [Group G] {n : ℕ}
    (hG : isAt G n) {D : DFA A Q} (f : G →* Equiv.Perm Q) (hf : Injective f)
    (hmem : ∀ g : G, permEnd (f g) ∈ transitionMonoid D) : n ≤ dfaGroupCapacity D := by
  have hsub : PermSubgroupIn D f.range := by
    rintro h ⟨g, rfl⟩
    exact hmem g
  have hcard : Nat.card f.range = n := by
    rw [← hG, capacity]
    exact (Nat.card_congr (Equiv.ofInjective f hf)).symm
  calc n = Nat.card f.range := hcard.symm
  _ ≤ dfaGroupCapacity D := le_dfaGroupCapacity hsub

/-- **Exclusion.** A recognizer with group complexity `0` has no lattice node of
capacity `≥ 2` among its Krohn-Rhodes components. -/
theorem not_groupDivides_of_groupComplexityZero {D : DFA A Q} (hD : GroupComplexityZero D)
    {G : Type*} [Group G] {n : ℕ} (hG : isAt G n) (hn : 2 ≤ n) :
    ¬ GroupDivides (transitionMonoid D) G := by
  intro hdiv
  have h1 := card_eq_one_of_isAperiodic_of_groupDivides hD hdiv
  rw [isAt, capacity, h1] at hG
  omega

end KrohnRhodes
