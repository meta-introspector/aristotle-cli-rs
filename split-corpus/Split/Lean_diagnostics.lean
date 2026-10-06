import Mathlib

-- spec: opaque Lean.diagnostics : Lean.Option Bool
opaque Lean.diagnostics : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
