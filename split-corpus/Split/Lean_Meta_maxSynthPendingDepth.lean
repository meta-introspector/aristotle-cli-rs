import Mathlib

-- spec: opaque Lean.Meta.maxSynthPendingDepth : Lean.Option Nat
opaque Lean.Meta.maxSynthPendingDepth : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
