import Split.List_Pairwise_cons
import Split.List_Pairwise
import Split.Membership_mem
import Split.List_Pairwise_below
import Split.List_cons
import Split.List
import Split.List_instMembership

-- List.Pairwise.below.cons from environment
-- constructor List.Pairwise.below.cons : forall {α : Type.{u}} {R : α -> α -> Prop} {motive : forall (a._@._internal._hyg.0 : List.{u} α), (List.Pairwise.{u} α R a._@._internal._hyg.0) -> Prop} {a : α} {l : List.{u} α} (a._@._internal._hyg.0 : forall (a' : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l a') -> (R a a')) (a_1._@._internal._hyg.0 : List.Pairwise.{u} α R l), (List.Pairwise.below.{u} α R motive l a_1._@._internal._hyg.0) -> (motive l a_1._@._internal._hyg.0) -> (List.Pairwise.below.{u} α R motive (List.cons.{u} α a l) (List.Pairwise.cons.{u} α R a l a._@._internal._hyg.0 a_1._@._internal._hyg.0))

-- Stub: this file represents the declaration `List.Pairwise.below.cons`.
-- In a full split, the body would be extracted from the environment.
