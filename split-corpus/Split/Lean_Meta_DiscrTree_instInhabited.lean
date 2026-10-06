import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiscrTree.instInhabited : forall {α : Type}, Inhabited.{1} (Lean.Meta.DiscrTree α)
def Lean.Meta.DiscrTree.instInhabited : forall {α : Type}, Inhabited.{1} (Lean.Meta.DiscrTree α) :=
  fun {α : Type} => Inhabited.mk.{1} (Lean.Meta.DiscrTree α) (Lean.Meta.DiscrTree.mk α (Lean.PersistentHashMap.mk.{0, 0} Lean.Meta.DiscrTree.Key (Lean.Meta.DiscrTree.Trie α) Lean.Meta.DiscrTree.instBEqKey Lean.Meta.DiscrTree.instHashableKey (Lean.PersistentHashMap.Node.entries.{0, 0} Lean.Meta.DiscrTree.Key (Lean.Meta.DiscrTree.Trie α) (Lean.PersistentHashMap.mkEmptyEntriesArray.{0, 0} Lean.Meta.DiscrTree.Key (Lean.Meta.DiscrTree.Trie α)))))
