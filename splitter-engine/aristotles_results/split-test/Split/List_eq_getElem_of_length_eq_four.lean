import Split.Eq_rec
import Split.instOfNatNat
import Split.List_cons
import Split.GetElem_getElem
import Split.List
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.List_length
import Split.rfl
import Split.List_nil

-- List.eq_getElem_of_length_eq_four from environment
-- theorem List.eq_getElem_of_length_eq_four : forall {α : Type.{u_1}} (l : List.{u_1} α) (hl : Eq.{1} Nat (List.length.{u_1} α l) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4))), Eq.{succ u_1} (List.{u_1} α) l (List.cons.{u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Eq.rec.{0, 1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (fun (x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.33 : Nat) (h._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.34 : Eq.{1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.33) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.33) List.eq_getElem_of_length_eq_four._proof_1 (List.length.{u_1} α l) (Eq.symm.{1} Nat (List.length.{u_1} α l) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) hl))) (List.cons.{u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Eq.rec.{0, 1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (fun (x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.49 : Nat) (h._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.50 : Eq.{1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.49) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.49) List.eq_getElem_of_length_eq_four._proof_2 (List.length.{u_1} α l) (Eq.symm.{1} Nat (List.length.{u_1} α l) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) hl))) (List.cons.{u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (Eq.rec.{0, 1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (fun (x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.65 : Nat) (h._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.66 : Eq.{1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.65) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.65) List.eq_getElem_of_length_eq_four._proof_3 (List.length.{u_1} α l) (Eq.symm.{1} Nat (List.length.{u_1} α l) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) hl))) (List.cons.{u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l (OfNat.ofNat.{0} Nat 3 (instOfNatNat 3)) (Eq.rec.{0, 1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (fun (x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.81 : Nat) (h._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.82 : Eq.{1} Nat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.81) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 3 (instOfNatNat 3)) x._@.Init.Data.List.Lemmas.799960788._hygCtx._hyg.81) List.eq_getElem_of_length_eq_four._proof_4 (List.length.{u_1} α l) (Eq.symm.{1} Nat (List.length.{u_1} α l) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) hl))) (List.nil.{u_1} α)))))

-- Stub: this file represents the declaration `List.eq_getElem_of_length_eq_four`.
-- In a full split, the body would be extracted from the environment.
