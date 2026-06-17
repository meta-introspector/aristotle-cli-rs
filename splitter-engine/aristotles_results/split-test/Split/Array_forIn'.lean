import Split.Array_forIn'_loop
import Split.Array_instMembership
import Split.Membership_mem
import Split.ForInStep
import Split.Array
import Split.Monad
import Split.Array_size

-- Array.forIn' from environment
-- def Array.forIn' : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α), β -> (forall (a : α), (Membership.mem.{u, u} α (Array.{u} α) (Array.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) -> (m β)
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.forIn'`.
-- In a full split, the body would be extracted from the environment.
