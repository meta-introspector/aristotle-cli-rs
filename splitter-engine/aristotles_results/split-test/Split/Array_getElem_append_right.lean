import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_size_append
import Split.congrArg
import Split.HSub_hSub
import Split.Eq_rec
import Split.Eq_mp
import Split.Fin_mk
import Split.id
import Split.instSubNat
import Split.Array_toList_append
import Split.Array_length_toList
import Split.LE_le
import Split.instLENat
import Split.Array_toList
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.List_get_of_eq
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.List_instAppend
import Split.List_instGetElemNatLtLength
import Split.Eq_symm
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_getElem_append_right
import Split.Nat_sub_lt_left_of_lt_add

-- Array.getElem_append_right from environment
-- theorem Array.getElem_append_right : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys))} (hle : LE.le.{0} Nat instLENat (Array.size.{u_1} α xs) i), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys) i h) (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) ys (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (Array.size.{u_1} α xs)) (Nat.sub_lt_left_of_lt_add (Array.size.{u_1} α xs) i (Array.size.{u_1} α ys) hle (Eq.rec.{0, 1} Nat (Array.size.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys)) (fun (x._@.Init.Data.Array.Lemmas.1805039414._hygCtx._hyg.68 : Nat) (h._@.Init.Data.Array.Lemmas.1805039414._hygCtx._hyg.69 : Eq.{1} Nat (Array.size.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys)) x._@.Init.Data.Array.Lemmas.1805039414._hygCtx._hyg.68) => LT.lt.{0} Nat instLTNat i x._@.Init.Data.Array.Lemmas.1805039414._hygCtx._hyg.68) h (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Array.size.{u_1} α xs) (Array.size.{u_1} α ys)) (Array.size_append.{u_1} α xs ys))))

-- Stub: this file represents the declaration `Array.getElem_append_right`.
-- In a full split, the body would be extracted from the environment.
