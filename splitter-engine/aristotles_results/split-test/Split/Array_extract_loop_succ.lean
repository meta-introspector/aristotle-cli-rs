import Split.Eq_mpr
import Split.Array_push
import Split.congrArg
import Split.dif_pos
import Split.id
import Split.Array_extract_loop_eq_1
import Split.instOfNatNat
import Split.dite
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.Unit
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Array_getInternal
import Split.Array_extract_loop
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Array_size
import Split.Not
import Split.Array_appendCore_loop_match_1

-- Array.extract_loop_succ from environment
-- theorem Array.extract_loop_succ : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {size : Nat} {start : Nat} (h : LT.lt.{0} Nat instLTNat start (Array.size.{u_1} α xs)), Eq.{succ u_1} (Array.{u_1} α) (Array.extract.loop.{u_1} α xs (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) size (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) start ys) (Array.extract.loop.{u_1} α xs size (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (Array.push.{u_1} α ys (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) xs start h)))

-- Stub: this file represents the declaration `Array.extract_loop_succ`.
-- In a full split, the body would be extracted from the environment.
