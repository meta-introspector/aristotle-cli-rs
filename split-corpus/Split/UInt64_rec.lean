import Mathlib

-- spec: recursor UInt64.rec : forall {motive : UInt64 -> Sort.{u}}, (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))), motive (UInt64.ofBitVec toBitVec)) -> (forall (t : UInt64), motive t)
