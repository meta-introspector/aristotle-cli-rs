import Split.List_Pairwise_cons
import Split.List_Pairwise
import Split.List_mem_cons_of_mem
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.List_Pairwise_nil
import Split.List_instMembership
import Split.List_mem_cons_self
import Split.List_Pairwise_rec
import Split.List_nil

-- List.Pairwise.imp_of_mem from environment
-- theorem List.Pairwise.imp_of_mem : forall {α : Type.{u_1}} {l : List.{u_1} α} {R : α -> α -> Prop} {S : α -> α -> Prop}, (forall {a : α} {b : α}, (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l b) -> (R a b) -> (S a b)) -> (List.Pairwise.{u_1} α R l) -> (List.Pairwise.{u_1} α S l)

-- Stub: this file represents the declaration `List.Pairwise.imp_of_mem`.
-- In a full split, the body would be extracted from the environment.
