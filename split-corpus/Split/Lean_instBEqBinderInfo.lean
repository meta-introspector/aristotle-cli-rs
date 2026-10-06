import Mathlib

set_option pp.all true
-- spec: Lean.instBEqBinderInfo : BEq.{0} Lean.BinderInfo
def Lean.instBEqBinderInfo : BEq.{0} Lean.BinderInfo :=
  BEq.mk.{0} Lean.BinderInfo Lean.instBEqBinderInfo.beq
