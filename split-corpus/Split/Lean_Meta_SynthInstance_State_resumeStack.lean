import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.State.resumeStack : Lean.Meta.SynthInstance.State -> (Array.{0} (Prod.{0, 0} Lean.Meta.SynthInstance.ConsumerNode Lean.Meta.SynthInstance.Answer))
def Lean.Meta.SynthInstance.State.resumeStack : Lean.Meta.SynthInstance.State -> (Array.{0} (Prod.{0, 0} Lean.Meta.SynthInstance.ConsumerNode Lean.Meta.SynthInstance.Answer)) :=
  fun (self : Lean.Meta.SynthInstance.State) => self.3
