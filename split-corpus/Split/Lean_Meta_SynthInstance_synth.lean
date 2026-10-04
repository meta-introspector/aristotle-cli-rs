import Mathlib

-- spec: opaque Lean.Meta.SynthInstance.synth : Lean.Meta.SynthInstance.SynthM (Option.{0} Lean.Meta.AbstractMVarsResult)
opaque Lean.Meta.SynthInstance.synth : Lean.Meta.SynthInstance.SynthM (Option.{0} Lean.Meta.AbstractMVarsResult) :=
  Inhabited.default.{1} (Lean.Meta.SynthInstance.SynthM (Option.{0} Lean.Meta.AbstractMVarsResult)) (Lean.Meta.SynthInstance.instInhabitedSynthM (Option.{0} Lean.Meta.AbstractMVarsResult))
