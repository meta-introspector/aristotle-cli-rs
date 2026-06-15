import Split.UInt64
import Split.UInt64_ofBitVec
import Split.BitVec
import Split.instOfNatNat
import Split.Nat
import Split.OfNat_ofNat
import Split.UInt64_rec

-- UInt64.casesOn from environment
-- def UInt64.casesOn : forall {motive : UInt64 -> Sort.{u}} (t : UInt64), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))), motive (UInt64.ofBitVec toBitVec)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UInt64.casesOn`.
-- In a full split, the body would be extracted from the environment.
