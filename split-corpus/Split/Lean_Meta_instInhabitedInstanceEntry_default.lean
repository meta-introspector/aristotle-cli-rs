import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instInhabitedInstanceEntry.default : Lean.Meta.InstanceEntry
def Lean.Meta.instInhabitedInstanceEntry.default : Lean.Meta.InstanceEntry :=
  Lean.Meta.InstanceEntry.mk (Inhabited.default.{1} (Array.{0} Lean.Meta.InstanceKey) (Array.instInhabited.{0} Lean.Meta.InstanceKey)) (Inhabited.default.{1} Lean.Expr Lean.instInhabitedExpr) (Inhabited.default.{1} Nat instInhabitedNat) (Inhabited.default.{1} (Option.{0} Lean.Name) (instInhabitedOption.{0} Lean.Name)) (Inhabited.default.{1} (Array.{0} Nat) (Array.instInhabited.{0} Nat)) (Inhabited.default.{1} Lean.AttributeKind Lean.instInhabitedAttributeKind)
