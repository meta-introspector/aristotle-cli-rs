import Split.List_Pairwise_cons
import Split.List_Pairwise
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.And
import Split.Iff
import Split.List_instMembership
import Split.And_intro
import Split.Iff_intro

-- List.pairwise_cons from environment
-- theorem List.pairwise_cons : forall {α : Type.{u}} {R : α -> α -> Prop} {a : α} {l : List.{u} α}, Iff (List.Pairwise.{u} α R (List.cons.{u} α a l)) (And (forall (a' : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l a') -> (R a a')) (List.Pairwise.{u} α R l))

-- Stub: this file represents the declaration `List.pairwise_cons`.
-- In a full split, the body would be extracted from the environment.
