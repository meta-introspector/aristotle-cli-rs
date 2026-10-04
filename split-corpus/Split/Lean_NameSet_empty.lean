import Mathlib

set_option pp.all true
-- spec: Lean.NameSet.empty : Lean.NameSet
def Lean.NameSet.empty : Lean.NameSet :=
  Std.TreeSet.empty.{0} Lean.Name Lean.Name.quickCmp
