import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.config : Lean.Meta.Context -> Lean.Meta.Config
def Lean.Meta.Context.config : Lean.Meta.Context -> Lean.Meta.Config :=
  fun (c : Lean.Meta.Context) => Lean.Meta.ConfigWithKey.config (Lean.Meta.Context.keyedConfig c)
