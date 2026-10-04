import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedLocalDecl : Inhabited.{1} Lean.LocalDecl
def Lean.instInhabitedLocalDecl : Inhabited.{1} Lean.LocalDecl :=
  Inhabited.mk.{1} Lean.LocalDecl Lean.instInhabitedLocalDecl.default
