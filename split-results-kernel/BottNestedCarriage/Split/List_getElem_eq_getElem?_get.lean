import Split.GetElem?_toGetElem
import Split.congrArg
import Split.get_getElem?
import Split.List_instGetElem?NatLtLength
import Split.GetElem_getElem
import Split.List
import Split.Option_get
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Nat_decLt
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.List_instGetElemNatLtLength
import Split.Eq
import Split.List_length
import Split.List_instLawfulGetElemNatLtLength
import Split.Eq_trans

-- List.getElem_eq_getElem?_get from environment
-- theorem List.getElem_eq_getElem?_get : forall {α : Type.{u_1}} {l : List.{u_1} α} {i : Nat} (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l)), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l i h) (Option.get.{u_1} α (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l i) (List.getElem_eq_getElem?_get._proof_1.{u_1} α l i h))

-- Stub: this file represents the declaration `List.getElem_eq_getElem?_get`.
-- In a full split, the body would be extracted from the environment.
