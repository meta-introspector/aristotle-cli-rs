import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeKind : Inhabited.{1} Lean.AttributeKind
def Lean.instInhabitedAttributeKind : Inhabited.{1} Lean.AttributeKind :=
  Inhabited.mk.{1} Lean.AttributeKind Lean.instInhabitedAttributeKind.default
