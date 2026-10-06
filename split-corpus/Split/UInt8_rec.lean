import Mathlib

-- spec: recursor UInt8.rec : forall {motive : UInt8 -> Sort.{u}}, (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), motive (UInt8.ofBitVec toBitVec)) -> (forall (t : UInt8), motive t)
