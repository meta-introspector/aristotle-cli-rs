import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Config.toConfigWithKey : Lean.Meta.Config -> Lean.Meta.ConfigWithKey
def Lean.Meta.Config.toConfigWithKey : Lean.Meta.Config -> Lean.Meta.ConfigWithKey :=
  fun (c : Lean.Meta.Config) => _private.Lean.Meta.Basic.0.Lean.Meta.ConfigWithKey.mk c (Lean.Meta.ConfigWithKey._private_1 c)
