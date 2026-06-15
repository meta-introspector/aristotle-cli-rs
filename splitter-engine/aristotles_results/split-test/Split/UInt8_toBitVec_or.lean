import Split.instHOrOfOrOp
import Split.BitVec_instOrOp
import Split.instOrOpUInt8
import Split.BitVec
import Split.instOfNatNat
import Split.UInt8_toBitVec
import Split.HOr_hOr
import Split.Nat
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq
import Split.rfl

-- UInt8.toBitVec_or from environment
-- theorem UInt8.toBitVec_or : forall (a : UInt8) (b : UInt8), Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (UInt8.toBitVec (HOr.hOr.{0, 0, 0} UInt8 UInt8 UInt8 (instHOrOfOrOp.{0} UInt8 instOrOpUInt8) a b)) (HOr.hOr.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (instHOrOfOrOp.{0} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec.instOrOp (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) (UInt8.toBitVec a) (UInt8.toBitVec b))

-- Stub: this file represents the declaration `UInt8.toBitVec_or`.
-- In a full split, the body would be extracted from the environment.
