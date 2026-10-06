import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedIRPhases.default : Lean.IRPhases
def Lean.instInhabitedIRPhases.default : Lean.IRPhases :=
  Lean.IRPhases.runtime
