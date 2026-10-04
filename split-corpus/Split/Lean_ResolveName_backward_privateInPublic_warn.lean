import Mathlib

-- spec: opaque Lean.ResolveName.backward.privateInPublic.warn : Lean.Option Bool
opaque Lean.ResolveName.backward.privateInPublic.warn : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
