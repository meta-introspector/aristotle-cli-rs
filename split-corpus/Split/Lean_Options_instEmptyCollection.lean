import Mathlib

set_option pp.all true
-- spec: Lean.Options.instEmptyCollection : EmptyCollection.{0} Lean.Options
def Lean.Options.instEmptyCollection : EmptyCollection.{0} Lean.Options :=
  EmptyCollection.mk.{0} Lean.Options Lean.Options.empty
