import Split.Eq_mpr
import Split.congrArg
import Split.List_map
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Eq_rec
import Split.id
import Split.Option_some_inj
import Split.List_getElem?_map
import Split.GetElem_getElem
import Split.List
import Split.Option_map
import Split.List_getElem?_eq_getElem
import Split.Nat
import Split.LT_lt
import Split.List_length_map
import Split.Eq_refl
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.List_instGetElemNatLtLength
import Split.Eq_symm
import Split.Eq
import Split.List_length
import Split.Option

-- List.getElem_map from environment
-- theorem List.getElem_map : forall {α : Type.{u_1}} {β : Type.{u_2}} (f : α -> β) {l : List.{u_1} α} {i : Nat} {h : LT.lt.{0} Nat instLTNat i (List.length.{u_2} β (List.map.{u_1, u_2} α β f l))}, Eq.{succ u_2} β (GetElem.getElem.{u_2, 0, u_2} (List.{u_2} β) Nat β (fun (as : List.{u_2} β) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_2} β as)) (List.instGetElemNatLtLength.{u_2} β) (List.map.{u_1, u_2} α β f l) i h) (f (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l i (Eq.rec.{0, 1} Nat (List.length.{u_2} β (List.map.{u_1, u_2} α β f l)) (fun (x._@.Init.Data.List.Lemmas.4212817347._hygCtx._hyg.51 : Nat) (h._@.Init.Data.List.Lemmas.4212817347._hygCtx._hyg.52 : Eq.{1} Nat (List.length.{u_2} β (List.map.{u_1, u_2} α β f l)) x._@.Init.Data.List.Lemmas.4212817347._hygCtx._hyg.51) => LT.lt.{0} Nat instLTNat i x._@.Init.Data.List.Lemmas.4212817347._hygCtx._hyg.51) h (List.length.{u_1} α l) (List.length_map.{u_1, u_2} α β l f))))

-- Stub: this file represents the declaration `List.getElem_map`.
-- In a full split, the body would be extracted from the environment.
