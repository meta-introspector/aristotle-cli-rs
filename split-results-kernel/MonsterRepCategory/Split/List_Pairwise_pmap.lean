import Split.Iff_mpr
import Split.List_Pairwise
import Split.Membership_mem
import Split.List_pairwise_pmap
import Split.List_pmap
import Split.List
import Split.List_Pairwise_imp_of_mem
import Split.List_instMembership

-- List.Pairwise.pmap from environment
-- theorem List.Pairwise.pmap : forall {α : Type.{u_1}} {R : α -> α -> Prop} {β : Type.{u_2}} {l : List.{u_1} α}, (List.Pairwise.{u_1} α R l) -> (forall {p : α -> Prop} {f : forall (a : α), (p a) -> β} (h : forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l x) -> (p x)) {S : β -> β -> Prop}, (forall {{x : α}} (hx : p x) {{y : α}} (hy : p y), (R x y) -> (S (f x hx) (f y hy))) -> (List.Pairwise.{u_2} β S (List.pmap.{u_1, u_2} α β p f l h)))

-- Stub: this file represents the declaration `List.Pairwise.pmap`.
-- In a full split, the body would be extracted from the environment.
