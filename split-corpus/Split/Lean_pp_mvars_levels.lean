import Mathlib

-- spec: opaque Lean.pp.mvars.levels : Lean.Option Bool
opaque Lean.pp.mvars.levels : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
