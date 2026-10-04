import Mathlib

-- spec: opaque Std.Format.format.width : Lean.Option Nat
opaque Std.Format.format.width : Lean.Option Nat :=
  Inhabited.default.{1} (Lean.Option Nat) (Lean.instInhabitedOption Nat instInhabitedNat)
