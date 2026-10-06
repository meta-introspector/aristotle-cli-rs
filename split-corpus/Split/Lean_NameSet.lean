import Mathlib

set_option pp.all true
-- spec: Lean.NameSet : Type
def Lean.NameSet : Type :=
  Std.TreeSet.{0} Lean.Name Lean.Name.quickCmp
