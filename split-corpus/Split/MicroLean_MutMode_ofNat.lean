import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.ofNat : Nat -> MicroLean.MutMode
def MicroLean.MutMode.ofNat : Nat -> MicroLean.MutMode :=
  fun (n : Nat) => cond.{1} MicroLean.MutMode (Nat.ble n 0) MicroLean.MutMode.borrowed (cond.{1} MicroLean.MutMode (Nat.ble n 1) MicroLean.MutMode.mutBorrow MicroLean.MutMode.owned)
