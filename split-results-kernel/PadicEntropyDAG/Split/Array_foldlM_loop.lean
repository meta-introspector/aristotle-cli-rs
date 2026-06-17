import Split.Pure_pure
import Split.Monad_toApplicative
import Split.Nat_brecOn
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Applicative_toPure
import Split.dite
import Split.Array
import Split.GetElem_getElem
import Split.Nat_below
import Split.instHAdd
import Split.Unit
import Split.Array_foldlM_loop_match_1
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_decLt
import Split.instAddNat
import Split.Monad_toBind
import Split.Bind_bind
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Monad
import Split.Nat_succ
import Split.Array_size
import Split.Not

-- Array.foldlM.loop from environment
-- def Array.foldlM.loop : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.8 : Monad.{v, w} m], (β -> α -> (m β)) -> (forall (as : Array.{u} α) (stop : Nat), (LE.le.{0} Nat instLENat stop (Array.size.{u} α as)) -> Nat -> Nat -> β -> (m β))
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.foldlM.loop`.
-- In a full split, the body would be extracted from the environment.
