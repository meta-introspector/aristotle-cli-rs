import Split.UInt32_toBitVec
import Split.BitVec_instHShiftRight
import Split.BitVec_instOfNat
import Split.BitVec
import Split.instHMod
import Split.instOfNatNat
import Split.instHShiftRightOfShiftRight
import Split.HMod_hMod
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.UInt32
import Split.instShiftRightUInt32
import Split.OfNat_ofNat
import Split.Eq
import Split.BitVec_instMod
import Split.rfl

-- UInt32.toBitVec_shiftRight from environment
-- theorem UInt32.toBitVec_shiftRight : forall (a : UInt32) (b : UInt32), Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (UInt32.toBitVec (HShiftRight.hShiftRight.{0, 0, 0} UInt32 UInt32 UInt32 (instHShiftRightOfShiftRight.{0} UInt32 instShiftRightUInt32) a b)) (HShiftRight.hShiftRight.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec.instHShiftRight (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (UInt32.toBitVec a) (HMod.hMod.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (instHMod.{0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec.instMod (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)))) (UInt32.toBitVec b) (OfNat.ofNat.{0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) 32 (BitVec.instOfNat (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) 32))))

-- Stub: this file represents the declaration `UInt32.toBitVec_shiftRight`.
-- In a full split, the body would be extracted from the environment.
