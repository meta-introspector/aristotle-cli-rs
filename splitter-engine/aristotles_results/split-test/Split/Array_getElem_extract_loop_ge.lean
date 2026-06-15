import Split.Array_getElem_extract_loop_lt
import Split.Eq_mpr
import Split.GetElem
import Split.Nat_recAux
import Split.Array_push
import Split.congrArg
import Split.HEq_refl
import Split.Classical_byContradiction
import Split.Nat_add_sub_assoc
import Split.Nat_le_add_right
import Split.HSub_hSub
import Split.Eq_rec
import Split.GE_ge
import Split.Eq_mp
import Split.Array_getElem_extract_loop_ge_aux
import Split.Nat_lt_succ_self
import Split.Eq_casesOn
import Split.Nat_lt_of_le_of_lt
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array_extract_loop_succ
import Split.dite
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat_lt_of_le_of_ne
import Split.Nat
import Split.LT_lt
import Split.Array_extract_loop
import Split.Eq_ndrec
import Split.instAddNat
import Split.Nat_add_sub_add_right
import Split.Eq_refl
import Split.HEq
import Split.Nat_add_sub_cancel
import Split.Array_size_push
import Split.Nat_add_zero
import Split.instDecidableEqNat
import Split.Array_size_extract_loop
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Nat_lt_of_lt_of_le
import Split.Array_size
import Split.Not
import Split.Min_min
import Split.instMinNat
import Split.Array_getElem_push_eq
import Split.Nat_add_right_comm
import Split.Nat_zero_min

-- Array.getElem_extract_loop_ge from environment
-- theorem Array.getElem_extract_loop_ge : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {size : Nat} {start : Nat} (hge : GE.ge.{0} Nat instLENat i (Array.size.{u_1} α ys)) (h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (Array.extract.loop.{u_1} α xs size start ys))), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (Array.extract.loop.{u_1} α xs size start ys) i h) (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) xs (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start i) (Array.size.{u_1} α ys)) (Array.getElem_extract_loop_ge_aux.{u_1} α i xs ys size start hge h))

-- Stub: this file represents the declaration `Array.getElem_extract_loop_ge`.
-- In a full split, the body would be extracted from the environment.
