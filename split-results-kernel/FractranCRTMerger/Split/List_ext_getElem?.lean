import Split.List_brecOn
import Split.Eq_mpr
import Split.False
import Split.Option_some_noConfusion
import Split.getElem?_neg
import Split.Option_ctorIdx
import Split.congrArg
import Split.False_elim
import Split.List_instGetElem?NatLtLength
import Split.noConfusion_of_Nat
import Split.Option_some_injEq
import Split.Option_some
import Split.Eq_mp
import Split.id
import Split.instOfNatNat
import Split.List_cons
import Split.Option_none
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.getElem?_pos
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.eq_of_heq
import Split.instAddNat
import Split.List_below
import Split.HEq
import Split.congrFun'
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.OfNat_ofNat
import Split.not_false_eq_true
import Split.eq_false'
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.List_ctorIdx
import Split.Not
import Split.List_instLawfulGetElemNatLtLength
import Split.rfl
import Split.Eq_trans
import Split.List_nil
import Split.Option

-- List.ext_getElem? from environment
-- theorem List.ext_getElem? : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, (forall (i : Nat), Eq.{succ u_1} (Option.{u_1} α) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l₁ i) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l₂ i)) -> (Eq.{succ u_1} (List.{u_1} α) l₁ l₂)

-- Stub: this file represents the declaration `List.ext_getElem?`.
-- In a full split, the body would be extracted from the environment.
