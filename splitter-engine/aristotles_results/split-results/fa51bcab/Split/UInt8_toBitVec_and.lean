import Split.BitVec_instAndOp
import Split.BitVec
import Split.instOfNatNat
import Split.UInt8_toBitVec
import Split.Nat
import Split.HAnd_hAnd
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq
import Split.instHAndOfAndOp
import Split.instAndOpUInt8
import Split.rfl

-- UInt8.toBitVec_and from environment
-- theorem UInt8.toBitVec_and : forall (a : UInt8) (b : UInt8), Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (UInt8.toBitVec (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) a b)) (HAnd.hAnd.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (instHAndOfAndOp.{0} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec.instAndOp (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) (UInt8.toBitVec a) (UInt8.toBitVec b))

-- Stub: this file represents the declaration `UInt8.toBitVec_and`.
-- In a full split, the body would be extracted from the environment.
