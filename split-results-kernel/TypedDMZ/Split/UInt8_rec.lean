import Split.BitVec
import Split.instOfNatNat
import Split.Nat
import Split.OfNat_ofNat
import Split.UInt8_ofBitVec
import Split.UInt8

-- UInt8.rec from environment
-- recursor UInt8.rec : forall {motive : UInt8 -> Sort.{u}}, (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), motive (UInt8.ofBitVec toBitVec)) -> (forall (t : UInt8), motive t)

-- Stub: this file represents the declaration `UInt8.rec`.
-- In a full split, the body would be extracted from the environment.
