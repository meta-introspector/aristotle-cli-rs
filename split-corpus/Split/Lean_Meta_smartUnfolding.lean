import Mathlib

-- spec: opaque Lean.Meta.smartUnfolding : Lean.Option Bool
opaque Lean.Meta.smartUnfolding : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
