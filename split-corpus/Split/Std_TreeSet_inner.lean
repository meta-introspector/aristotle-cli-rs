import Mathlib

set_option pp.all true
-- spec: Std.TreeSet.inner : forall {α : Type.{u}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.TreeSet._auto_1}, (Std.TreeSet.{u} α cmp) -> (Std.TreeMap.{u, 0} α Unit cmp)
def Std.TreeSet.inner : forall {α : Type.{u}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.TreeSet._auto_1}, (Std.TreeSet.{u} α cmp) -> (Std.TreeMap.{u, 0} α Unit cmp) :=
  fun (α : Type.{u}) (cmp : autoParam.{succ u} (α -> α -> Ordering) Std.TreeSet._auto_1) (self : Std.TreeSet.{u} α cmp) => self.1
