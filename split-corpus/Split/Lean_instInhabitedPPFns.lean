import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedPPFns : Inhabited.{1} Lean.PPFns
def Lean.instInhabitedPPFns : Inhabited.{1} Lean.PPFns :=
  Inhabited.mk.{1} Lean.PPFns Lean.instInhabitedPPFns.default
