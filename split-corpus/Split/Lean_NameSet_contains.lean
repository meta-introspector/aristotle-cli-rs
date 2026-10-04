import Mathlib

set_option pp.all true
-- spec: Lean.NameSet.contains : Lean.NameSet -> Lean.Name -> Bool
def Lean.NameSet.contains : Lean.NameSet -> Lean.Name -> Bool :=
  fun (s : Lean.NameSet) (n : Lean.Name) => Std.TreeSet.contains.{0} Lean.Name Lean.Name.quickCmp s n
