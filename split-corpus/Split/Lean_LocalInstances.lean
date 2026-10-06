import Mathlib

set_option pp.all true
-- spec: Lean.LocalInstances : Type
def Lean.LocalInstances : Type :=
  Array.{0} Lean.LocalInstance
