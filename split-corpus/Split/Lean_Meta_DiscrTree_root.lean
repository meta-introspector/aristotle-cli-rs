import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiscrTree.root : forall {α : Type}, (Lean.Meta.DiscrTree α) -> (Lean.PersistentHashMap.{0, 0} Lean.Meta.DiscrTree.Key (Lean.Meta.DiscrTree.Trie α) Lean.Meta.DiscrTree.instBEqKey Lean.Meta.DiscrTree.instHashableKey)
def Lean.Meta.DiscrTree.root : forall {α : Type}, (Lean.Meta.DiscrTree α) -> (Lean.PersistentHashMap.{0, 0} Lean.Meta.DiscrTree.Key (Lean.Meta.DiscrTree.Trie α) Lean.Meta.DiscrTree.instBEqKey Lean.Meta.DiscrTree.instHashableKey) :=
  fun (α : Type) (self : Lean.Meta.DiscrTree α) => self.1
