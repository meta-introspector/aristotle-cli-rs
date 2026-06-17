import Split.id
import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk
import Split.Nat
import Split.BottNested_LayerPayload
import Split.BottNested_LayerPayload_noConfusion
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq

-- BottNested.LayerPayload.mk.noConfusion from environment
-- def BottNested.LayerPayload.mk.noConfusion : forall {P : Sort.{u}} {cid : MonsterTrain.CID} {payload : Nat} {layer : Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))} {cid' : MonsterTrain.CID} {payload' : Nat} {layer' : Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))}, (Eq.{1} BottNested.LayerPayload (BottNested.LayerPayload.mk cid payload layer) (BottNested.LayerPayload.mk cid' payload' layer')) -> ((Eq.{1} MonsterTrain.CID cid cid') -> (Eq.{1} Nat payload payload') -> (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) layer layer') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `BottNested.LayerPayload.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
