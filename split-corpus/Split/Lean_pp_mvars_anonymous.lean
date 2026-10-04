import Mathlib

-- spec: opaque Lean.pp.mvars.anonymous : Lean.Option Bool
opaque Lean.pp.mvars.anonymous : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
