import Mathlib

set_option pp.all true
-- spec: ByteArray.extract : ByteArray -> Nat -> Nat -> ByteArray
def ByteArray.extract : ByteArray -> Nat -> Nat -> ByteArray :=
  fun (a : ByteArray) (b : Nat) (e : Nat) => ByteArray.copySlice a b ByteArray.empty (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) e b) Bool.true
