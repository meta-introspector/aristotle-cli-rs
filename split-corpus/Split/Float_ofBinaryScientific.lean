import Mathlib

set_option pp.all true
-- spec: Float.ofBinaryScientific : Nat -> Int -> Float
def Float.ofBinaryScientific : Nat -> Int -> Float :=
  fun (m : Nat) (e : Int) => have s : Nat := HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Nat.log2 m) (OfNat.ofNat.{0} Nat 63 (instOfNatNat 63)); have m : UInt64 := Nat.toUInt64 (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m s); have e : Int := HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) e (Nat.cast.{0} Int instNatCastInt s); Float.scaleB (UInt64.toFloat m) e
