import Split.Pure_pure
import Split.List_brecOn
import Split.Monad_toApplicative
import Split.Membership_mem
import Split.Exists
import Split.Applicative_toPure
import Split.ForInStep
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.List_instMembership
import Split.List_forIn'_loop_match_5
import Split.List_forIn'_loop_match_3
import Split.List_below
import Split.Monad_toBind
import Split.Bind_bind
import Split.List_instAppend
import Split.Monad
import Split.Eq
import Split.HAppend_hAppend
import Split.List_nil

-- List.forIn'.loop from environment
-- def List.forIn'.loop : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.List.Control.4042975923._hygCtx._hyg.7 : Monad.{v, w} m] (as : List.{u} α), (forall (a : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) -> (forall (as' : List.{u} α), β -> (Exists.{succ u} (List.{u} α) (fun (bs : List.{u} α) => Eq.{succ u} (List.{u} α) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) bs as') as)) -> (m β))
-- (definition body omitted)

-- Stub: this file represents the declaration `List.forIn'.loop`.
-- In a full split, the body would be extracted from the environment.
