import Mathlib

-- spec: opaque Lean.pp.beta : Lean.Option Bool
opaque Lean.pp.beta : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
