import Split.Eq_mpr
import Split.instNeZeroNatHAdd_1
import Split.False
import Split.Fin_foldr_succ
import Split.Nat_recAux
import Split.Fin_succ
import Split.congrArg
import Split.False_elim
import Split.GetElem_getElem_congr_simp
import Split.List_ofFn
import Split.List_length_ofFn
import Split.Fin_foldr
import Split.Eq_mp
import Split.Fin_mk
import Split.id
import Split.Fin_instOfNat
import Split.instOfNatNat
import Split.List_cons
import Split.GetElem_getElem
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_instNeZeroSucc
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.eq_true
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.List_length
import Split.Eq_trans
import Split.List_nil

-- List.getElem_ofFn from environment
-- theorem List.getElem_ofFn : forall {n : Nat} {α : Type.{u_1}} {i : Nat} {f : (Fin n) -> α} (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α (List.ofFn.{u_1} α n f))), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) (List.ofFn.{u_1} α n f) i h) (f (Fin.mk n i (List.getElem_ofFn._proof_1.{u_1} n α i f h)))

-- Stub: this file represents the declaration `List.getElem_ofFn`.
-- In a full split, the body would be extracted from the environment.
