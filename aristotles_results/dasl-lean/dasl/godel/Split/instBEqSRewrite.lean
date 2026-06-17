import Mathlib

set_option pp.all true
-- spec: instBEqSRewrite : BEq.{0} SRewrite
def instBEqSRewrite : BEq.{0} SRewrite :=
  BEq.mk.{0} SRewrite instBEqSRewrite.beq
