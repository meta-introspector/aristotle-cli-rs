import Split.Eq_mpr
import Split.congrArg
import Split.Int_casesOn
import Split.id
import Split.Int_instNegInt
import Split.Int_ofNat
import Split.Int
import Split.Nat_cast
import Split.Int_natCast_succ
import Split.instHAdd
import Split.Iff
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.propext
import Split.Int_negSucc_eq
import Split.Eq_ndrec
import Split.Int_instAdd
import Split.Eq_refl
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.Neg_neg

-- Int.wlog_sign from environment
-- theorem Int.wlog_sign : forall {P : Int -> Prop}, (forall (i : Int), Iff (P i) (P (Neg.neg.{0} Int Int.instNegInt i))) -> (forall (n : Nat), P (Nat.cast.{0} Int instNatCastInt n)) -> (forall (i : Int), P i)

-- Stub: this file represents the declaration `Int.wlog_sign`.
-- In a full split, the body would be extracted from the environment.
