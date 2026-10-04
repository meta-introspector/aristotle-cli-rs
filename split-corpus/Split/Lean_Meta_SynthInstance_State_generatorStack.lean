import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.State.generatorStack : Lean.Meta.SynthInstance.State -> (Array.{0} Lean.Meta.SynthInstance.GeneratorNode)
def Lean.Meta.SynthInstance.State.generatorStack : Lean.Meta.SynthInstance.State -> (Array.{0} Lean.Meta.SynthInstance.GeneratorNode) :=
  fun (self : Lean.Meta.SynthInstance.State) => self.2
