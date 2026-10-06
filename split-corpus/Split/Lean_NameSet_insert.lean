import Mathlib

set_option pp.all true
-- spec: Lean.NameSet.insert : Lean.NameSet -> Lean.Name -> Lean.NameSet
def Lean.NameSet.insert : Lean.NameSet -> Lean.Name -> Lean.NameSet :=
  fun (s : Lean.NameSet) (n : Lean.Name) => Std.TreeSet.insert.{0} Lean.Name Lean.Name.quickCmp s n
