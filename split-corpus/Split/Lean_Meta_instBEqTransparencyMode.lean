import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instBEqTransparencyMode : BEq.{0} Lean.Meta.TransparencyMode
def Lean.Meta.instBEqTransparencyMode : BEq.{0} Lean.Meta.TransparencyMode :=
  BEq.mk.{0} Lean.Meta.TransparencyMode Lean.Meta.instBEqTransparencyMode.beq
