import Split.UInt32_toBitVec
import Split.BitVec_instHShiftRight
import Split.UInt32_toNat
import Split.BitVec_instHShiftRightNat
import Split.BitVec_instOfNat
import Split.congrArg
import Split.BitVec
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.UInt32_toBitVec_shiftRight
import Split.BitVec_toNat
import Split.BitVec_ofNat
import Split.instHShiftRightOfShiftRight
import Split.HMod_hMod
import Split.BitVec_toNat_ofNat
import Split.Nat_instShiftRight
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.UInt32
import Split.congrFun'
import Split.instShiftRightUInt32
import Split.OfNat_ofNat
import Split.Eq
import Split.BitVec_instMod
import Split.Eq_trans

-- UInt32.toNat_shiftRight from environment
-- theorem UInt32.toNat_shiftRight : forall (a : UInt32) (b : UInt32), Eq.{1} Nat (UInt32.toNat (HShiftRight.hShiftRight.{0, 0, 0} UInt32 UInt32 UInt32 (instHShiftRightOfShiftRight.{0} UInt32 instShiftRightUInt32) a b)) (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) (UInt32.toNat a) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (UInt32.toNat b) (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))))

-- Stub: this file represents the declaration `UInt32.toNat_shiftRight`.
-- In a full split, the body would be extracted from the environment.
