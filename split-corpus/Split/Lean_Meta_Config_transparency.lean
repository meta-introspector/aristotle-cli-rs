import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Config.transparency : Lean.Meta.Config -> Lean.Meta.TransparencyMode
def Lean.Meta.Config.transparency : Lean.Meta.Config -> Lean.Meta.TransparencyMode :=
  fun (self : Lean.Meta.Config) => self.10
