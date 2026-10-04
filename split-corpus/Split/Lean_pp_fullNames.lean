import Mathlib

-- spec: opaque Lean.pp.fullNames : Lean.Option Bool
opaque Lean.pp.fullNames : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
