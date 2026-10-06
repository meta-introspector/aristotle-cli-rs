import Mathlib

-- spec: opaque Lean.pp.raw.showInfo : Lean.Option Bool
opaque Lean.pp.raw.showInfo : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
