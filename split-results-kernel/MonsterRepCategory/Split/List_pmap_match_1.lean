import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.List_instMembership
import Split.List_casesOn
import Split.List_nil

-- List.pmap.match_1 from environment
-- def List.pmap.match_1 : forall {α : Type.{u_1}} {P : α -> Prop} (motive : forall (x._@.Init.Data.List.Attach.3509371473._hygCtx.53.Init.Data.List.Attach.3509371473._hygCtx._hyg.72 : List.{u_1} α), (forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) x._@.Init.Data.List.Attach.3509371473._hygCtx.53.Init.Data.List.Attach.3509371473._hygCtx._hyg.72 a) -> (P a)) -> Sort.{u_2}) (x._@.Init.Data.List.Attach.3509371473._hygCtx.53.Init.Data.List.Attach.3509371473._hygCtx._hyg.72 : List.{u_1} α) (x._@.Init.Data.List.Attach.3509371473._hygCtx.54.Init.Data.List.Attach.3509371473._hygCtx._hyg.75 : forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) x._@.Init.Data.List.Attach.3509371473._hygCtx.53.Init.Data.List.Attach.3509371473._hygCtx._hyg.72 a) -> (P a)), (forall (x._@.Init.Data.List.Attach.3509371473._hygCtx._hyg.84 : forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) (List.nil.{u_1} α) a) -> (P a)), motive (List.nil.{u_1} α) x._@.Init.Data.List.Attach.3509371473._hygCtx._hyg.84) -> (forall (a : α) (l : List.{u_1} α) (H : forall (a_1 : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) (List.cons.{u_1} α a l) a_1) -> (P a_1)), motive (List.cons.{u_1} α a l) H) -> (motive x._@.Init.Data.List.Attach.3509371473._hygCtx.53.Init.Data.List.Attach.3509371473._hygCtx._hyg.72 x._@.Init.Data.List.Attach.3509371473._hygCtx.54.Init.Data.List.Attach.3509371473._hygCtx._hyg.75)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.pmap.match_1`.
-- In a full split, the body would be extracted from the environment.
