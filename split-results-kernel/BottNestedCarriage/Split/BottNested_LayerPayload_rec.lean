import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk
import Split.Nat
import Split.BottNested_LayerPayload
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Fin

-- BottNested.LayerPayload.rec from environment
-- recursor BottNested.LayerPayload.rec : forall {motive : BottNested.LayerPayload -> Sort.{u}}, (forall (cid : MonsterTrain.CID) (payload : Nat) (layer : Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), motive (BottNested.LayerPayload.mk cid payload layer)) -> (forall (t : BottNested.LayerPayload), motive t)

-- Stub: this file represents the declaration `BottNested.LayerPayload.rec`.
-- In a full split, the body would be extracted from the environment.
