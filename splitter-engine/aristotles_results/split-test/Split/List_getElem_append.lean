import Split.Eq_mpr
import Split.Decidable_casesOn
import Split.congrArg
import Split.HSub_hSub
import Split.Decidable
import Split.Eq_mp
import Split.dif_pos
import Split.id
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.dif_neg
import Split.dite
import Split.GetElem_getElem
import Split.List_getElem_append_left
import Split.instHAppendOfAppend
import Split.List
import Split.instHSub
import Split.Nat
import Split.LT_lt
import Split.Nat_decLt
import Split.Eq_refl
import Split.instLTNat
import Split.List_instAppend
import Split.List_instGetElemNatLtLength
import Split.Eq
import Split.List_length
import Split.Not
import Split.HAppend_hAppend
import Split.List_getElem_append_right

-- List.getElem_append from environment
-- theorem List.getElem_append : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {i : Nat} (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂))), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂) i h) (dite.{succ u_1} α (LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l₁)) (Nat.decLt i (List.length.{u_1} α l₁)) (fun (h' : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l₁)) => GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l₁ i h') (fun (h' : Not (LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l₁))) => GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l₂ (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (List.length.{u_1} α l₁)) (List.getElem_append._proof_1.{u_1} α l₁ l₂ i h h')))

-- Stub: this file represents the declaration `List.getElem_append`.
-- In a full split, the body would be extracted from the environment.
