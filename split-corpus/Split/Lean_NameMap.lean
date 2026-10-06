import Mathlib

set_option pp.all true
-- spec: Lean.NameMap : Type -> Type
def Lean.NameMap : Type -> Type :=
  fun (α : Type) => Std.TreeMap.{0, 0} Lean.Name α Lean.Name.quickCmp
