import Mathlib

set_option pp.all true
-- spec: Lean.Data.Trie.empty : forall {α : Type}, Lean.Data.Trie α
def Lean.Data.Trie.empty : forall {α : Type}, Lean.Data.Trie α :=
  fun {α : Type} => Lean.Data.Trie.leaf α (Option.none.{0} α)
