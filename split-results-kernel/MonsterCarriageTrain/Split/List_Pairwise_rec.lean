import Split.List_Pairwise_cons
import Split.List_Pairwise
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.List_Pairwise_nil
import Split.List_instMembership
import Split.List_nil

-- List.Pairwise.rec from environment
-- recursor List.Pairwise.rec : forall {α : Type.{u}} {R : α -> α -> Prop} {motive : forall (a._@._internal._hyg.0 : List.{u} α), (List.Pairwise.{u} α R a._@._internal._hyg.0) -> Prop}, (motive (List.nil.{u} α) (List.Pairwise.nil.{u} α R)) -> (forall {a : α} {l : List.{u} α} (a._@._internal._hyg.0 : forall (a' : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l a') -> (R a a')) (a_1._@._internal._hyg.0 : List.Pairwise.{u} α R l), (motive l a_1._@._internal._hyg.0) -> (motive (List.cons.{u} α a l) (List.Pairwise.cons.{u} α R a l a._@._internal._hyg.0 a_1._@._internal._hyg.0))) -> (forall {a._@._internal._hyg.0 : List.{u} α} (t : List.Pairwise.{u} α R a._@._internal._hyg.0), motive a._@._internal._hyg.0 t)

-- Stub: this file represents the declaration `List.Pairwise.rec`.
-- In a full split, the body would be extracted from the environment.
