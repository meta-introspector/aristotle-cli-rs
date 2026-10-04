import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.State.result? : Lean.Meta.SynthInstance.State -> (Option.{0} Lean.Meta.AbstractMVarsResult)
def Lean.Meta.SynthInstance.State.result? : Lean.Meta.SynthInstance.State -> (Option.{0} Lean.Meta.AbstractMVarsResult) :=
  fun (self : Lean.Meta.SynthInstance.State) => self.1
