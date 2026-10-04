import Mathlib

-- spec: opaque Lean.Meta.synthInstance.maxSize : Lean.Option Nat
opaque Lean.Meta.synthInstance.maxSize : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
