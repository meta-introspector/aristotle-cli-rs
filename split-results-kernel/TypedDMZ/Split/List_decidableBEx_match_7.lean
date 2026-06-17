import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Membership_mem
import Split.Exists
import Split.List
import Split.And
import Split.List_instMembership
import Split.Decidable_isFalse
import Split.Not

-- List.decidableBEx.match_7 from environment
-- def List.decidableBEx.match_7 : forall {α : Type.{u_1}} (p : α -> Prop) (xs : List.{u_1} α) (motive : (Decidable (Exists.{succ u_1} α (fun (x : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) (p x)))) -> Sort.{u_2}) (x._@.Init.Data.List.Basic.2678156253._hygCtx._hyg.115 : Decidable (Exists.{succ u_1} α (fun (x : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) (p x)))), (forall (h₂ : Exists.{succ u_1} α (fun (x : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) (p x))), motive (Decidable.isTrue (Exists.{succ u_1} α (fun (x : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) (p x))) h₂)) -> (forall (h₂ : Not (Exists.{succ u_1} α (fun (x : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) (p x)))), motive (Decidable.isFalse (Exists.{succ u_1} α (fun (x : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) xs x) (p x))) h₂)) -> (motive x._@.Init.Data.List.Basic.2678156253._hygCtx._hyg.115)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.decidableBEx.match_7`.
-- In a full split, the body would be extracted from the environment.
