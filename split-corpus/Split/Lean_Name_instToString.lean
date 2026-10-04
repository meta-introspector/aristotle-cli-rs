import Mathlib

set_option pp.all true
-- spec: Lean.Name.instToString : ToString.{0} Lean.Name
def Lean.Name.instToString : ToString.{0} Lean.Name :=
  ToString.mk.{0} Lean.Name (fun (n : Lean.Name) => Lean.Name.toString n Bool.true)
