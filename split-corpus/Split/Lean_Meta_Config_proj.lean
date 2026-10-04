import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Config.proj : Lean.Meta.Config -> Lean.Meta.ProjReductionKind
def Lean.Meta.Config.proj : Lean.Meta.Config -> Lean.Meta.ProjReductionKind :=
  fun (self : Lean.Meta.Config) => self.15
