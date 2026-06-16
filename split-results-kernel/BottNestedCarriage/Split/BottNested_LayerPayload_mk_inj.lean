import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk_noConfusion
import Split.BottNested_LayerPayload_mk
import Split.And
import Split.Nat
import Split.BottNested_LayerPayload
import Split.And_intro
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq

-- BottNested.LayerPayload.mk.inj from environment
-- theorem BottNested.LayerPayload.mk.inj : forall {cid : MonsterTrain.CID} {payload : Nat} {layer : Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))} {cid_1 : MonsterTrain.CID} {payload_1 : Nat} {layer_1 : Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))}, (Eq.{1} BottNested.LayerPayload (BottNested.LayerPayload.mk cid payload layer) (BottNested.LayerPayload.mk cid_1 payload_1 layer_1)) -> (And (Eq.{1} MonsterTrain.CID cid cid_1) (And (Eq.{1} Nat payload payload_1) (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) layer layer_1)))

-- Stub: this file represents the declaration `BottNested.LayerPayload.mk.inj`.
-- In a full split, the body would be extracted from the environment.
