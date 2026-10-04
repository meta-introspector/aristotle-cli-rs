import Mathlib

-- spec: opaque Lean.maxRecDepth : Lean.Option Nat
opaque Lean.maxRecDepth : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
