import Split.Int_decidableDvd
import Split.Int_instDiv
import Split.Dvd_dvd
import Split.instHDiv
import Split.congrArg
import Split.HSub_hSub
import Split.Int_decLe
import Split.Int_sign
import Split.HDiv_hDiv
import Split.Int_add_sub_cancel
import Split.Int
import Split.LE_le
import Split.Int_tdiv_eq_ediv
import Split.Int_instDvd
import Split.Int_tdiv
import Split.instHAdd
import Split.instHSub
import Split.instOfNat
import Split.HAdd_hAdd
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Int_instAdd
import Split.Int_instSub
import Split.congrFun'
import Split.Or
import Split.OfNat_ofNat
import Split.Eq
import Split.instDecidableOr
import Split.Int_instLEInt
import Split.Eq_trans
import Split.ite

-- Int.ediv_eq_tdiv from environment
-- theorem Int.ediv_eq_tdiv : forall {a : Int} {b : Int}, Eq.{1} Int (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (Int.tdiv a b) (ite.{1} Int (Or (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (Dvd.dvd.{0} Int Int.instDvd b a)) (instDecidableOr (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (Dvd.dvd.{0} Int Int.instDvd b a) (Int.decLe (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (Int.decidableDvd b a)) (OfNat.ofNat.{0} Int 0 (instOfNat 0)) (Int.sign b)))

-- Stub: this file represents the declaration `Int.ediv_eq_tdiv`.
-- In a full split, the body would be extracted from the environment.
