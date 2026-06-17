import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Membership_mem
import Split.List
import Split.List_instMembership
import Split.Decidable_isFalse
import Split.Not

-- List.instDecidablePairwise.match_1 from environment
-- def List.instDecidablePairwise.match_1 : forall {α : Type.{u_1}} {R : α -> α -> Prop} (hd : α) (tl : List.{u_1} α) (motive : (Decidable (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) tl x) -> (R hd x))) -> Sort.{u_2}) (x._@.Init.Data.List.Basic.3979818597._hygCtx._hyg.76 : Decidable (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) tl x) -> (R hd x))), (forall (hf : Not (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) tl x) -> (R hd x))), motive (Decidable.isFalse (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) tl x) -> (R hd x)) hf)) -> (forall (ht' : forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) tl x) -> (R hd x)), motive (Decidable.isTrue (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) tl x) -> (R hd x)) ht')) -> (motive x._@.Init.Data.List.Basic.3979818597._hygCtx._hyg.76)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.instDecidablePairwise.match_1`.
-- In a full split, the body would be extracted from the environment.
