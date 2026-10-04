import Mathlib

-- spec: recursor UInt32.rec : forall {motive : UInt32 -> Sort.{u}}, (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))), motive (UInt32.ofBitVec toBitVec)) -> (forall (t : UInt32), motive t)
