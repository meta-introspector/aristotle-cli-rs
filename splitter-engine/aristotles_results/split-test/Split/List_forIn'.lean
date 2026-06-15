import Split.Membership_mem
import Split.ForInStep
import Split.List
import Split.List_instMembership
import Split.List_forIn'_loop
import Split.Monad

-- List.forIn' from environment
-- def List.forIn' : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.List.Control.4042975923._hygCtx._hyg.7 : Monad.{v, w} m] (as : List.{u} α), β -> (forall (a : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) -> (m β)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.forIn'`.
-- In a full split, the body would be extracted from the environment.
