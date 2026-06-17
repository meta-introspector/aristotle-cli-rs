import Mathlib

-- spec: opaque Mathlib.Tactic.Contrapose.contrapose.negate_iff : Lean.Option Bool
opaque Mathlib.Tactic.Contrapose.contrapose.negate_iff : Lean.Option Bool :=
  Inhabited.default.{1} (Lean.Option Bool) (Lean.instInhabitedOption Bool instInhabitedBool)
