import Mathlib

set_option pp.all true
-- spec: Lean.Data.Trie.instInhabited : forall {α : Type}, Inhabited.{1} (Lean.Data.Trie α)
def Lean.Data.Trie.instInhabited : forall {α : Type}, Inhabited.{1} (Lean.Data.Trie α) :=
  fun {α : Type} => Inhabited.mk.{1} (Lean.Data.Trie α) (Lean.Data.Trie.empty α)
