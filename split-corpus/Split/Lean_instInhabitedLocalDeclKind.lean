import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedLocalDeclKind : Inhabited.{1} Lean.LocalDeclKind
def Lean.instInhabitedLocalDeclKind : Inhabited.{1} Lean.LocalDeclKind :=
  Inhabited.mk.{1} Lean.LocalDeclKind Lean.instInhabitedLocalDeclKind.default
