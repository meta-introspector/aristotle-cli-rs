import Split.Pure_pure
import Split.Monad_toApplicative
import Split.Array_forIn'_loop_match_1
import Split.HSub_hSub
import Split.Array_instMembership
import Split.Membership_mem
import Split.Nat_brecOn
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Applicative_toPure
import Split.ForInStep
import Split.Array
import Split.GetElem_getElem
import Split.Nat_below
import Split.instHAdd
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Monad_toBind
import Split.Bind_bind
import Split.Array_forIn'_loop_match_3
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Monad
import Split.Nat_succ
import Split.Array_size

-- Array.forIn'.loop from environment
-- def Array.forIn'.loop : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α), (forall (a : α), (Membership.mem.{u, u} α (Array.{u} α) (Array.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) -> (forall (i : Nat), (LE.le.{0} Nat instLENat i (Array.size.{u} α as)) -> β -> (m β))
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.forIn'.loop`.
-- In a full split, the body would be extracted from the environment.
