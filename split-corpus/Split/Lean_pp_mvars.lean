import Mathlib

-- spec: opaque Lean.pp.mvars : Lean.Option Bool
opaque Lean.pp.mvars : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
