import Split.BitVec
import Split.instOfNatNat
import Split.UInt32_ofBitVec
import Split.UInt32_rec
import Split.Nat
import Split.UInt32
import Split.OfNat_ofNat

-- UInt32.casesOn from environment
-- def UInt32.casesOn : forall {motive : UInt32 -> Sort.{u}} (t : UInt32), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))), motive (UInt32.ofBitVec toBitVec)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UInt32.casesOn`.
-- In a full split, the body would be extracted from the environment.
