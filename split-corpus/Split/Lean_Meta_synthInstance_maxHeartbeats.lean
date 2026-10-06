import Mathlib

-- spec: opaque Lean.Meta.synthInstance.maxHeartbeats : Lean.Option Nat
opaque Lean.Meta.synthInstance.maxHeartbeats : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
