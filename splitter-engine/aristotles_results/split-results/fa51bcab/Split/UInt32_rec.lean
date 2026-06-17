import Split.BitVec
import Split.instOfNatNat
import Split.UInt32_ofBitVec
import Split.Nat
import Split.UInt32
import Split.OfNat_ofNat

-- UInt32.rec from environment
-- recursor UInt32.rec : forall {motive : UInt32 -> Sort.{u}}, (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))), motive (UInt32.ofBitVec toBitVec)) -> (forall (t : UInt32), motive t)

-- Stub: this file represents the declaration `UInt32.rec`.
-- In a full split, the body would be extracted from the environment.
