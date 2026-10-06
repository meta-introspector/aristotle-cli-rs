import Mathlib

set_option pp.all true
-- spec: Lean.NameSet.instEmptyCollection : EmptyCollection.{0} Lean.NameSet
def Lean.NameSet.instEmptyCollection : EmptyCollection.{0} Lean.NameSet :=
  EmptyCollection.mk.{0} Lean.NameSet Lean.NameSet.empty
