import Mathlib

-- spec: opaque Lean.diagnostics.threshold : Lean.Option Nat
opaque Lean.diagnostics.threshold : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
