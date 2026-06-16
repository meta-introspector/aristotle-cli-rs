import Split.HEq_refl
import Split.False_elim
import Split.List_instGetElem?NatLtLength
import Split.noConfusion_of_Nat
import Split.Option_some
import Split.instOfNatNat
import Split.List_rec
import Split.Nat_le_step
import Split.List_cons
import Split.Nat_casesAuxOn
import Split.GetElem_getElem
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
import Split.GetElem?_getElem?
import Split.Nat_le_casesOn
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.List_nil
import Split.Option

-- List.getElem?_eq_getElem from environment
-- theorem List.getElem?_eq_getElem : forall {α : Type.{u_1}} {l : List.{u_1} α} {i : Nat} (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l)), Eq.{succ u_1} (Option.{u_1} α) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l i) (Option.some.{u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l i h))

-- Stub: this file represents the declaration `List.getElem?_eq_getElem`.
-- In a full split, the body would be extracted from the environment.
