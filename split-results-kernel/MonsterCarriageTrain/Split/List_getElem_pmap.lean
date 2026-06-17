import Split.Nat_zero_le
import Split.Nat_not_lt_of_le
import Split.congrArg
import Split.Membership_mem
import Split.Eq_rec
import Split.id
import Split.instOfNatNat
import Split.List_rec
import Split.List_cons
import Split.Nat_casesAuxOn
import Split.GetElem_getElem
import Split.List_pmap
import Split.List
import Split.instHAdd
import Split.And
import Split.absurd
import Split.List_instMembership
import Split.And_right
import Split.And_left
import Split.HAdd_hAdd
import Split.Nat
import Split.List_getElem_mem
import Split.List_forall_mem_cons
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Iff_mp
import Split.List_length_pmap
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.List_length
import Split.Eq_trans
import Split.Nat_lt_of_succ_lt_succ
import Split.List_nil

-- List.getElem_pmap from environment
-- theorem List.getElem_pmap : forall {α : Type.{u_1}} {β : Type.{u_2}} {p : α -> Prop} (f : forall (a : α), (p a) -> β) {l : List.{u_1} α} (h : forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (p a)) {i : Nat} (hn : LT.lt.{0} Nat instLTNat i (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h))), Eq.{succ u_2} β (GetElem.getElem.{u_2, 0, u_2} (List.{u_2} β) Nat β (fun (as : List.{u_2} β) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_2} β as)) (List.instGetElemNatLtLength.{u_2} β) (List.pmap.{u_1, u_2} α β p f l h) i hn) (f (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l i (Eq.rec.{0, 1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h)) (fun (x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.103 : Nat) (h._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.104 : Eq.{1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h)) x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.103) => LT.lt.{0} Nat instLTNat i x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.103) hn (List.length.{u_1} α l) (List.length_pmap.{u_1, u_2} α β p f l h))) (h (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l i (Eq.rec.{0, 1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h)) (fun (x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.103 : Nat) (h._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.104 : Eq.{1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h)) x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.103) => LT.lt.{0} Nat instLTNat i x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.103) hn (List.length.{u_1} α l) (List.length_pmap.{u_1, u_2} α β p f l h))) (List.getElem_mem.{u_1} α l i (Eq.rec.{0, 1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h)) (fun (x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.114 : Nat) (h._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.115 : Eq.{1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l h)) x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.114) => LT.lt.{0} Nat instLTNat i x._@.Init.Data.List.Attach.4037952062._hygCtx._hyg.114) hn (List.length.{u_1} α l) (List.length_pmap.{u_1, u_2} α β p f l h)))))

-- Stub: this file represents the declaration `List.getElem_pmap`.
-- In a full split, the body would be extracted from the environment.
