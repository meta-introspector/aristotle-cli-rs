import Split.Pure_pure
import Split.Array_push
import Split.Monad_toApplicative
import Split.Nat_brecOn
import Split.instOfNatNat
import Split.Applicative_toPure
import Split.Array
import Split.GetElem_getElem
import Split.Nat_below
import Split.instHAdd
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Monad_toBind
import Split.Bind_bind
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Monad
import Split.Nat_succ
import Split.Eq
import Split.Array_size
import Split.Array_mapFinIdxM_map_match_1

-- Array.mapFinIdxM.map from environment
-- def Array.mapFinIdxM.map : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α), (forall (i : Nat), α -> (LT.lt.{0} Nat instLTNat i (Array.size.{u} α as)) -> (m β)) -> (forall (i : Nat) (j : Nat), (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i j) (Array.size.{u} α as)) -> (Array.{v} β) -> (m (Array.{v} β)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.mapFinIdxM.map`.
-- In a full split, the body would be extracted from the environment.
