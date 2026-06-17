import Split.Array_instAppend
import Split.List_getElem_append
import Split.dite_congr
import Split.congrArg
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.Array_casesOn
import Split.instSubNat
import Split.List_append_toArray
import Split.dite
import Split.List_toArray
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.List
import Split.List_size_toArray
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.Nat
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Nat_decLt
import Split.Eq_ndrec
import Split.Eq_mpr_not
import Split.Eq_refl
import Split.instLTNat
import Split.List_instAppend
import Split.Array_mk
import Split.List_instGetElemNatLtLength
import Split.Eq_symm
import Split.Eq_mpr_prop
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.Not
import Split.HAppend_hAppend
import Split.Eq_trans

-- Array.getElem_append from environment
-- theorem Array.getElem_append : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α} (h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys))), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys) i h) (dite.{succ u_1} α (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Nat.decLt i (Array.size.{u_1} α xs)) (fun (h' : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) => GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) xs i h') (fun (h' : Not (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs))) => GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) ys (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (Array.size.{u_1} α xs)) (Array.getElem_append._proof_2.{u_1} α i xs ys h h')))

-- Stub: this file represents the declaration `Array.getElem_append`.
-- In a full split, the body would be extracted from the environment.
