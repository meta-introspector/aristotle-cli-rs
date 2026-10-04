import Mathlib

set_option pp.all true
-- spec: Std.TreeSet.insert : forall {α : Type.{u}} {cmp : α -> α -> Ordering}, (Std.TreeSet.{u} α cmp) -> α -> (Std.TreeSet.{u} α cmp)
def Std.TreeSet.insert : forall {α : Type.{u}} {cmp : α -> α -> Ordering}, (Std.TreeSet.{u} α cmp) -> α -> (Std.TreeSet.{u} α cmp) :=
  fun {α : Type.{u}} {cmp : α -> α -> Ordering} (l : Std.TreeSet.{u} α cmp) (a : α) => Std.TreeSet.mk.{u} α cmp (Std.TreeMap.insertIfNew.{u, 0} α Unit cmp (Std.TreeSet.inner.{u} α cmp l) a Unit.unit)
