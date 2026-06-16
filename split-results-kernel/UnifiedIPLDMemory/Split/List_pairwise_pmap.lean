import Split.Eq_mpr
import Split.List_Pairwise
import Split.congrArg
import Split.Membership_mem
import Split.Exists
import Split.Eq_mp
import Split.id
import Split.List_rec
import Split.List_cons
import Split.And_casesOn
import Split.iff_self
import Split.List_pmap
import Split.List
import Split.And
import Split.Iff
import Split.List_instMembership
import Split.And_right
import Split.And_left
import Split.implies_congr
import Split.List_forall_mem_cons
import Split.congr
import Split.True
import Split.Iff_intro
import Split.propext
import Split.Iff_mp
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Or
import Split.Eq
import Split.rfl
import Split.Eq_trans
import Split.List_nil
import Split.forall_congr

-- List.pairwise_pmap from environment
-- theorem List.pairwise_pmap : forall {β : Type.{u_1}} {α : Type.{u_2}} {R : α -> α -> Prop} {p : β -> Prop} {f : forall (b : β), (p b) -> α} {l : List.{u_1} β} (h : forall (x : β), (Membership.mem.{u_1, u_1} β (List.{u_1} β) (List.instMembership.{u_1} β) l x) -> (p x)), Iff (List.Pairwise.{u_2} α R (List.pmap.{u_1, u_2} β α p f l h)) (List.Pairwise.{u_1} β (fun (b₁ : β) (b₂ : β) => forall (h₁ : p b₁) (h₂ : p b₂), R (f b₁ h₁) (f b₂ h₂)) l)

-- Stub: this file represents the declaration `List.pairwise_pmap`.
-- In a full split, the body would be extracted from the environment.
