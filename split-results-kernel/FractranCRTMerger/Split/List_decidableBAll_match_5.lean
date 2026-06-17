import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Membership_mem
import Split.List
import Split.List_instMembership
import Split.Decidable_isFalse
import Split.Not

-- List.decidableBAll.match_5 from environment
-- def List.decidableBAll.match_5 : forall {α : Type.{u_1}} (p : α -> Prop) (xs : List.{u_1} α) (motive : (Decidable (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) -> (p x))) -> Sort.{u_2}) (x._@.Init.Data.List.Basic.3911725664._hygCtx._hyg.100 : Decidable (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) -> (p x))), (forall (h₂ : forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) -> (p x)), motive (Decidable.isTrue (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) -> (p x)) h₂)) -> (forall (h₂ : Not (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) -> (p x))), motive (Decidable.isFalse (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) -> (p x)) h₂)) -> (motive x._@.Init.Data.List.Basic.3911725664._hygCtx._hyg.100)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.decidableBAll.match_5`.
-- In a full split, the body would be extracted from the environment.
