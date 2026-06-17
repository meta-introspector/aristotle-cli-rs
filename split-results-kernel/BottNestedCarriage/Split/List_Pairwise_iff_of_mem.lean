import Split.Iff_mpr
import Split.List_Pairwise
import Split.Membership_mem
import Split.List
import Split.List_Pairwise_imp_of_mem
import Split.Iff
import Split.List_instMembership
import Split.Iff_intro
import Split.Iff_mp

-- List.Pairwise.iff_of_mem from environment
-- theorem List.Pairwise.iff_of_mem : forall {α : Type.{u_1}} {R : α -> α -> Prop} {S : α -> α -> Prop} {l : List.{u_1} α}, (forall {a : α} {b : α}, (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l b) -> (Iff (R a b) (S a b))) -> (Iff (List.Pairwise.{u_1} α R l) (List.Pairwise.{u_1} α S l))

-- Stub: this file represents the declaration `List.Pairwise.iff_of_mem`.
-- In a full split, the body would be extracted from the environment.
