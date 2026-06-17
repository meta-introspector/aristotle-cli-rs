import Split.dite_cond_eq_true
import Split.Eq_mpr
import Split.congrArg
import Split.List_ofFn
import Split.List_length_ofFn
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Eq_mp
import Split.Fin_mk
import Split.id
import Split.LE_le
import Split.instLENat
import Split.dif_neg
import Split.dite
import Split.GetElem_getElem
import Split.Option_none
import Split.List
import Split.List_getElem?_eq_getElem
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.eq_true
import Split.of_eq_true
import Split.Nat_decLt
import Split.List_getElem_ofFn
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.List_instGetElemNatLtLength
import Split.Fin
import Split.Eq
import Split.List_length
import Split.Not
import Split.List_instLawfulGetElemNatLtLength
import Split.Eq_trans
import Split.Option

-- List.getElem?_ofFn from environment
-- theorem List.getElem?_ofFn : forall {n : Nat} {α : Type.{u_1}} {i : Nat} {f : (Fin n) -> α}, Eq.{succ u_1} (Option.{u_1} α) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) (List.ofFn.{u_1} α n f) i) (dite.{succ u_1} (Option.{u_1} α) (LT.lt.{0} Nat instLTNat i n) (Nat.decLt i n) (fun (h : LT.lt.{0} Nat instLTNat i n) => Option.some.{u_1} α (f (Fin.mk n i h))) (fun (h : Not (LT.lt.{0} Nat instLTNat i n)) => Option.none.{u_1} α))

-- Stub: this file represents the declaration `List.getElem?_ofFn`.
-- In a full split, the body would be extracted from the environment.
