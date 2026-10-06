import Mathlib

set_option pp.all true
-- spec: Eigenspace.ofNat : Nat -> Eigenspace
def Eigenspace.ofNat : Nat -> Eigenspace :=
  fun (n : Nat) => cond.{1} Eigenspace (Nat.ble n 1) (cond.{1} Eigenspace (Nat.ble n 0) Eigenspace.earth Eigenspace.spoke) (cond.{1} Eigenspace (Nat.ble n 2) Eigenspace.hub Eigenspace.clock)
