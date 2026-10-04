import Mathlib

set_option pp.all true
-- spec: Lean.Options.empty : Lean.Options
def Lean.Options.empty : Lean.Options :=
  _private.Lean.Data.Options.0.Lean.Options.mk (EmptyCollection.emptyCollection.{0} (Lean.NameMap Lean.DataValue) (Lean.NameMap.instEmptyCollection Lean.DataValue)) Bool.false
