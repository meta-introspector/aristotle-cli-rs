import Mathlib

set_option pp.all true
-- spec: Lean.instEmptyCollectionFVarIdSet : EmptyCollection.{0} Lean.FVarIdSet
def Lean.instEmptyCollectionFVarIdSet : EmptyCollection.{0} Lean.FVarIdSet :=
  EmptyCollection.mk.{0} Lean.FVarIdSet Lean.instEmptyCollectionFVarIdSet._aux_1
