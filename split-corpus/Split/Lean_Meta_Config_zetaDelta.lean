import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Config.zetaDelta : Lean.Meta.Config -> Bool
def Lean.Meta.Config.zetaDelta : Lean.Meta.Config -> Bool :=
  fun (self : Lean.Meta.Config) => self.17
