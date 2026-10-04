import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.canUnfold? : Lean.Meta.Context -> (Option.{0} (Lean.Meta.Config -> Lean.ConstantInfo -> (Lean.Core.CoreM Bool)))
def Lean.Meta.Context.canUnfold? : Lean.Meta.Context -> (Option.{0} (Lean.Meta.Config -> Lean.ConstantInfo -> (Lean.Core.CoreM Bool))) :=
  fun (self : Lean.Meta.Context) => self.8
