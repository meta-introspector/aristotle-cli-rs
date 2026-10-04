import Mathlib

-- spec: opaque Lean.pp.privateNames : Lean.Option Bool
opaque Lean.pp.privateNames : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
