import Split.False
import Split.HEq_refl
import Split.False_elim
import Split.noConfusion_of_Nat
import Split.instOfNatNat
import Split.List_rec
import Split.Nat_le_step
import Split.List_cons
import Split.Nat_casesAuxOn
import Split.GetElem_getElem
import Split.List_append
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_le
import Split.Nat
import Split.LT_lt
import Split.Eq_ndrec
import Split.Nat_ctorIdx
import Split.instAddNat
import Split.Eq_refl
import Split.HEq
import Split.Nat_le_refl
import Split.instLTNat
import Split.Nat_le_casesOn
import Split.List_instAppend
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.List_nil

-- List.getElem_append_left from environment
-- theorem List.getElem_append_left : forall {α : Type.{u_1}} {i : Nat} {as : List.{u_1} α} {bs : List.{u_1} α} (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) {h' : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as bs))}, Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as bs) i h') (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) as i h)

-- Stub: this file represents the declaration `List.getElem_append_left`.
-- In a full split, the body would be extracted from the environment.
