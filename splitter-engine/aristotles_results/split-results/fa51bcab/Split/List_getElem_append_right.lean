import Split.Eq_mpr
import Split.False
import Split.congrArg
import Split.False_elim
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.noConfusion_of_Nat
import Split.Eq_mp
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.List_rec
import Split.LE_le
import Split.instLENat
import Split.List_cons
import Split.Nat_casesAuxOn
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat_le_zero_eq
import Split.Nat
import Split.LT_lt
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Nat_ctorIdx
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_succ_sub_succ
import Split.instLTNat
import Split.List_instAppend
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.eq_false'
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.Nat_sub_eq_zero_of_le
import Split.Eq_trans
import Split.Nat_lt_of_succ_lt_succ
import Split.List_nil

-- List.getElem_append_right from environment
-- theorem List.getElem_append_right : forall {α : Type.{u_1}} {as : List.{u_1} α} {bs : List.{u_1} α} {i : Nat} (h₁ : LE.le.{0} Nat instLENat (List.length.{u_1} α as) i) {h₂ : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as bs))}, Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as bs) i h₂) (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) bs (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (List.length.{u_1} α as)) (List.getElem_append_right._proof_1.{u_1} α as bs i h₁ h₂))

-- Stub: this file represents the declaration `List.getElem_append_right`.
-- In a full split, the body would be extracted from the environment.
