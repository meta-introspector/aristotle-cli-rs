import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedIRPhases : Inhabited.{1} Lean.IRPhases
def Lean.instInhabitedIRPhases : Inhabited.{1} Lean.IRPhases :=
  Inhabited.mk.{1} Lean.IRPhases Lean.instInhabitedIRPhases.default
