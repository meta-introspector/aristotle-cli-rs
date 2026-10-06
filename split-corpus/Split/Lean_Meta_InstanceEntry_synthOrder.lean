import Mathlib

set_option pp.all true
-- spec: Lean.Meta.InstanceEntry.synthOrder : Lean.Meta.InstanceEntry -> (Array.{0} Nat)
def Lean.Meta.InstanceEntry.synthOrder : Lean.Meta.InstanceEntry -> (Array.{0} Nat) :=
  fun (self : Lean.Meta.InstanceEntry) => self.5
