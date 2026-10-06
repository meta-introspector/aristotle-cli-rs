import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.keyedConfig : Lean.Meta.Context -> Lean.Meta.ConfigWithKey
def Lean.Meta.Context.keyedConfig : Lean.Meta.Context -> Lean.Meta.ConfigWithKey :=
  fun (self : Lean.Meta.Context) => self.1
