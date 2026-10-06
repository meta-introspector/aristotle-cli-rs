import Mathlib

-- spec: opaque Lean.pp.proofs : Lean.Option Bool
opaque Lean.pp.proofs : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
