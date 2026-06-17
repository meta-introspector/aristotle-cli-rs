import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.ofNat : Nat -> MicroLean.OwnershipMode
def MicroLean.OwnershipMode.ofNat : Nat -> MicroLean.OwnershipMode :=
  fun (n : Nat) => cond.{1} MicroLean.OwnershipMode (Nat.ble n 0) MicroLean.OwnershipMode.borrowed MicroLean.OwnershipMode.owned
