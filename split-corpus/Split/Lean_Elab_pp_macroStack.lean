import Mathlib

-- spec: opaque Lean.Elab.pp.macroStack : Lean.Option Bool
opaque Lean.Elab.pp.macroStack : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
