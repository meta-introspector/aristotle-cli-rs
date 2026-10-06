import Mathlib

-- spec: opaque IO.getNumHeartbeats : BaseIO Nat
opaque IO.getNumHeartbeats : BaseIO Nat :=
  Inhabited.default.{1} (BaseIO Nat) (instInhabitedOfMonad.{0, 0} Nat BaseIO instMonadBaseIO instInhabitedNat)
