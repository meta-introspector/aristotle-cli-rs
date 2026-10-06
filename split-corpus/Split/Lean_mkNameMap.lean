import Mathlib

set_option pp.all true
-- spec: Lean.mkNameMap : forall (α : Type), Lean.NameMap α
def Lean.mkNameMap : forall (α : Type), Lean.NameMap α :=
  fun (α : Type) => Std.TreeMap.empty.{0, 0} Lean.Name α Lean.Name.quickCmp
