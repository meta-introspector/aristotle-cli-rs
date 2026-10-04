import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.localInstances : Lean.Meta.Context -> Lean.LocalInstances
def Lean.Meta.Context.localInstances : Lean.Meta.Context -> Lean.LocalInstances :=
  fun (self : Lean.Meta.Context) => self.5
