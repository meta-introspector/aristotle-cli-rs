import Split.Eq_mpr
import Split.Int_neg_eq_comm
import Split.congrArg
import Split.Int_neg_negSucc
import Split.id
import Split.Int_instNegInt
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.iff_self
import Split.instHAdd
import Split.Iff
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.propext
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans

-- Int.neg_ofNat_eq_negSucc_iff from environment
-- theorem Int.neg_ofNat_eq_negSucc_iff : forall {a : Nat} {b : Nat}, Iff (Eq.{1} Int (Neg.neg.{0} Int Int.instNegInt (Nat.cast.{0} Int instNatCastInt a)) (Int.negSucc b)) (Eq.{1} Nat a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) b (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Int.neg_ofNat_eq_negSucc_iff`.
-- In a full split, the body would be extracted from the environment.
