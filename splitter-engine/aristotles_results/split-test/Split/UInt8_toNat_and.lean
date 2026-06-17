import Split.BitVec_instAndOp
import Split.Nat_instAndOp
import Split.congrArg
import Split.BitVec
import Split.instOfNatNat
import Split.BitVec_toNat
import Split.UInt8_toBitVec
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.HAnd_hAnd
import Split.UInt8_toNat
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq
import Split.instHAndOfAndOp
import Split.instAndOpUInt8
import Split.UInt8_toBitVec_and
import Split.Eq_trans

-- UInt8.toNat_and from environment
-- theorem UInt8.toNat_and : forall (a : UInt8) (b : UInt8), Eq.{1} Nat (UInt8.toNat (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) a b)) (HAnd.hAnd.{0, 0, 0} Nat Nat Nat (instHAndOfAndOp.{0} Nat Nat.instAndOp) (UInt8.toNat a) (UInt8.toNat b))

-- Stub: this file represents the declaration `UInt8.toNat_and`.
-- In a full split, the body would be extracted from the environment.
