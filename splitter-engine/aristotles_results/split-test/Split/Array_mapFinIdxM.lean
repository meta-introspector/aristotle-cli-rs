import Split.instOfNatNat
import Split.Array
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Monad
import Split.Array_size
import Split.Array_emptyWithCapacity
import Split.Array_mapFinIdxM_map

-- Array.mapFinIdxM from environment
-- def Array.mapFinIdxM : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α), (forall (i : Nat), α -> (LT.lt.{0} Nat instLTNat i (Array.size.{u} α as)) -> (m β)) -> (m (Array.{v} β))
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.mapFinIdxM`.
-- In a full split, the body would be extracted from the environment.
