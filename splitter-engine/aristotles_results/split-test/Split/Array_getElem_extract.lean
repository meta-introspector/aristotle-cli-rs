import Split.Eq_mpr
import Split.Nat_zero_le
import Split.congrArg
import Split.HSub_hSub
import Split.Array_getElem_extract_loop_ge_aux
import Split.id
import Split.instSubNat
import Split.Array_extract
import Split.List_toArray
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.Array_getElem_extract_aux
import Split.LT_lt
import Split.Array_extract_loop
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.Eq
import Split.Array_size
import Split.Min_min
import Split.instMinNat
import Split.Array_getElem_extract_loop_ge
import Split.List_nil

-- Array.getElem_extract from environment
-- theorem Array.getElem_extract : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {start : Nat} {stop : Nat} (h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (Array.extract.{u_1} α xs start stop))), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (Array.extract.{u_1} α xs start stop) i h) (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) xs (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start i) (Array.getElem_extract_aux.{u_1} α i xs start stop h))

-- Stub: this file represents the declaration `Array.getElem_extract`.
-- In a full split, the body would be extracted from the environment.
