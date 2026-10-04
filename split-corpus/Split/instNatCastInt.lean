import Mathlib

set_option pp.all true
-- spec: instNatCastInt : NatCast.{0} Int
def instNatCastInt : NatCast.{0} Int :=
  NatCast.mk.{0} Int (fun (n : Nat) => Int.ofNat n)
