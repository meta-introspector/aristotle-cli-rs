import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.instInhabitedScope : Inhabited.{1} Lean.Elab.Command.Scope
def Lean.Elab.Command.instInhabitedScope : Inhabited.{1} Lean.Elab.Command.Scope :=
  Inhabited.mk.{1} Lean.Elab.Command.Scope Lean.Elab.Command.instInhabitedScope.default
