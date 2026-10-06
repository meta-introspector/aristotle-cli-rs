import Mathlib

-- spec: opaque Lean.PrettyPrinter.pp.oneline : Lean.Option Bool
opaque Lean.PrettyPrinter.pp.oneline : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
