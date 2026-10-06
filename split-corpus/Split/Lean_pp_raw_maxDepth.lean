import Mathlib

-- spec: opaque Lean.pp.raw.maxDepth : Lean.Option Nat
opaque Lean.pp.raw.maxDepth : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
