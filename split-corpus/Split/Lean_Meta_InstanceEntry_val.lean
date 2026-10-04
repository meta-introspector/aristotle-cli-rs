import Mathlib

set_option pp.all true
-- spec: Lean.Meta.InstanceEntry.val : Lean.Meta.InstanceEntry -> Lean.Expr
def Lean.Meta.InstanceEntry.val : Lean.Meta.InstanceEntry -> Lean.Expr :=
  fun (self : Lean.Meta.InstanceEntry) => self.2
