import Mathlib

set_option pp.all true
-- spec: Std.TreeSet.contains : forall {α : Type.{u}} {cmp : α -> α -> Ordering}, (Std.TreeSet.{u} α cmp) -> α -> Bool
def Std.TreeSet.contains : forall {α : Type.{u}} {cmp : α -> α -> Ordering}, (Std.TreeSet.{u} α cmp) -> α -> Bool :=
  fun {α : Type.{u}} {cmp : α -> α -> Ordering} (l : Std.TreeSet.{u} α cmp) (a : α) => Std.TreeMap.contains.{u, 0} α Unit cmp (Std.TreeSet.inner.{u} α cmp l) a
