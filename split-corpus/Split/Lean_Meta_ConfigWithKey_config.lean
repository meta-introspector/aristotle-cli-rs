import Mathlib

set_option pp.all true
-- spec: Lean.Meta.ConfigWithKey.config : Lean.Meta.ConfigWithKey -> Lean.Meta.Config
def Lean.Meta.ConfigWithKey.config : Lean.Meta.ConfigWithKey -> Lean.Meta.Config :=
  fun (self : Lean.Meta.ConfigWithKey) => self.1
