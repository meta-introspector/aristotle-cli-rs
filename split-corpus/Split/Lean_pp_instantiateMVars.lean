import Mathlib

-- spec: opaque Lean.pp.instantiateMVars : Lean.Option Bool
opaque Lean.pp.instantiateMVars : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
