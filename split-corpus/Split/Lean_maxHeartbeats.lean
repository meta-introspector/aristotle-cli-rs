import Mathlib

-- spec: opaque Lean.maxHeartbeats : Lean.Option Nat
opaque Lean.maxHeartbeats : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
