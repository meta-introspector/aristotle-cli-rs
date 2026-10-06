import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedSyntax : Inhabited.{1} Lean.Syntax
def Lean.instInhabitedSyntax : Inhabited.{1} Lean.Syntax :=
  Inhabited.mk.{1} Lean.Syntax Lean.Syntax.missing
