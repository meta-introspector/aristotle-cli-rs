import Mathlib

set_option pp.all true
-- spec: Lean.instAppendName : Append.{0} Lean.Name
def Lean.instAppendName : Append.{0} Lean.Name :=
  Append.mk.{0} Lean.Name Lean.Name.append
