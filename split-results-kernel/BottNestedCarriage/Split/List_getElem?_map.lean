import Split.List_brecOn
import Split.congrArg
import Split.List_map
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.instHAdd
import Split.Option_map
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.getElem?_pos
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.List_length_map
import Split.of_eq_true
import Split.instAddNat
import Split.List_below
import Split.congrFun'
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.List_instLawfulGetElemNatLtLength
import Split.rfl
import Split.Eq_trans
import Split.List_nil
import Split.Option

-- List.getElem?_map from environment
-- theorem List.getElem?_map : forall {α : Type.{u_1}} {β : Type.{u_2}} {f : α -> β} {l : List.{u_1} α} {i : Nat}, Eq.{succ u_2} (Option.{u_2} β) (GetElem?.getElem?.{u_2, 0, u_2} (List.{u_2} β) Nat β (fun (as : List.{u_2} β) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_2} β as)) (List.instGetElem?NatLtLength.{u_2} β) (List.map.{u_1, u_2} α β f l) i) (Option.map.{u_1, u_2} α β f (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l i))

-- Stub: this file represents the declaration `List.getElem?_map`.
-- In a full split, the body would be extracted from the environment.
