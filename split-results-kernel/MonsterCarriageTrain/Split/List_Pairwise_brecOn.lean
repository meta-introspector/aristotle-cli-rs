import Split.List_Pairwise_below_nil
import Split.List_Pairwise
import Split.Membership_mem
import Split.List_Pairwise_below
import Split.List
import Split.List_instMembership
import Split.List_Pairwise_rec
import Split.List_Pairwise_below_cons

-- List.Pairwise.brecOn from environment
-- theorem List.Pairwise.brecOn : forall {α : Type.{u}} {R : α -> α -> Prop} {motive : forall (a._@._internal._hyg.0 : List.{u} α), (List.Pairwise.{u} α R a._@._internal._hyg.0) -> Prop} {a._@._internal._hyg.0 : List.{u} α} (t : List.Pairwise.{u} α R a._@._internal._hyg.0), (forall (a._@._internal._hyg.0 : List.{u} α) (t : List.Pairwise.{u} α R a._@._internal._hyg.0), (List.Pairwise.below.{u} α R motive a._@._internal._hyg.0 t) -> (motive a._@._internal._hyg.0 t)) -> (motive a._@._internal._hyg.0 t)

-- Stub: this file represents the declaration `List.Pairwise.brecOn`.
-- In a full split, the body would be extracted from the environment.
