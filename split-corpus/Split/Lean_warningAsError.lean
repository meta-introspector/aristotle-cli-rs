import Mathlib

-- spec: opaque Lean.warningAsError : Lean.Option Bool
opaque Lean.warningAsError : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
