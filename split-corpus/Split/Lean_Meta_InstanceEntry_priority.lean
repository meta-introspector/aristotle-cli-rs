import Mathlib

set_option pp.all true
-- spec: Lean.Meta.InstanceEntry.priority : Lean.Meta.InstanceEntry -> Nat
def Lean.Meta.InstanceEntry.priority : Lean.Meta.InstanceEntry -> Nat :=
  fun (self : Lean.Meta.InstanceEntry) => self.3
