import Split.UInt64
import Split.UInt64_ofBitVec
import Split.BitVec
import Split.instOfNatNat
import Split.Nat
import Split.OfNat_ofNat

-- UInt64.rec from environment
-- recursor UInt64.rec : forall {motive : UInt64 -> Sort.{u}}, (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))), motive (UInt64.ofBitVec toBitVec)) -> (forall (t : UInt64), motive t)

-- Stub: this file represents the declaration `UInt64.rec`.
-- In a full split, the body would be extracted from the environment.
