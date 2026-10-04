import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiscrTree.instBEqKey : BEq.{0} Lean.Meta.DiscrTree.Key
def Lean.Meta.DiscrTree.instBEqKey : BEq.{0} Lean.Meta.DiscrTree.Key :=
  BEq.mk.{0} Lean.Meta.DiscrTree.Key Lean.Meta.DiscrTree.instBEqKey.beq
