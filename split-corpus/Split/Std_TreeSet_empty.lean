import Mathlib

set_option pp.all true
-- spec: Std.TreeSet.empty : forall {α : Type.{u}} {cmp : α -> α -> Ordering}, Std.TreeSet.{u} α cmp
def Std.TreeSet.empty : forall {α : Type.{u}} {cmp : α -> α -> Ordering}, Std.TreeSet.{u} α cmp :=
  fun {α : Type.{u}} {cmp : α -> α -> Ordering} => Std.TreeSet.mk.{u} α cmp (Std.TreeMap.empty.{u, 0} α Unit cmp)
