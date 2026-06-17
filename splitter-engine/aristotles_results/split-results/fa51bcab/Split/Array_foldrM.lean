import Split.Pure_pure
import Split.Monad_toApplicative
import Split.Array_foldrM_fold
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Applicative_toPure
import Split.dite
import Split.Array
import Split.Nat
import Split.LT_lt
import Split.Nat_decLt
import Split.instLTNat
import Split.optParam
import Split.OfNat_ofNat
import Split.Monad
import Split.Array_size
import Split.Not
import Split.Nat_decLe
import Split.ite

-- Array.foldrM from environment
-- def Array.foldrM : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.237924737._hygCtx._hyg.8 : Monad.{v, w} m], (α -> β -> (m β)) -> β -> (forall (as : Array.{u} α), (optParam.{1} Nat (Array.size.{u} α as)) -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (m β))
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.foldrM`.
-- In a full split, the body would be extracted from the environment.
