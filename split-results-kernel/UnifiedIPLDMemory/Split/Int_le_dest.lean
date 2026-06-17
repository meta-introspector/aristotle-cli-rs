import Split.Eq_mpr
import Split.congrArg
import Split.Int_add_assoc
import Split.HSub_hSub
import Split.Exists
import Split.id
import Split.Int_add_left_neg
import Split.Int_instNegInt
import Split.Int_le_dest_sub
import Split.Int
import Split.LE_le
import Split.Int_add_comm
import Split.Nat_cast
import Split.instHAdd
import Split.instHSub
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.Exists_intro
import Split.of_eq_true
import Split.Int_instAdd
import Split.Int_instSub
import Split.congrFun'
import Split.instNatCastInt
import Split.Int_add_zero
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg
import Split.Int_instLEInt
import Split.Eq_trans

-- Int.le.dest from environment
-- theorem Int.le.dest : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt a b) -> (Exists.{1} Nat (fun (n : Nat) => Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (Nat.cast.{0} Int instNatCastInt n)) b))

-- Stub: this file represents the declaration `Int.le.dest`.
-- In a full split, the body would be extracted from the environment.
