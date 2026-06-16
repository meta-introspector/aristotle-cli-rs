import Split.List_map
import Split.MonsterTrain_CARBlock
import Split.BottNested_bottFold_match_1
import Split.instOfNatNat
import Split.MonsterTrain_CARBlock_mk
import Split.BottNested_flatten
import Split.List
import Split.BottNested_LayerPayload_payload
import Split.BottNested_LayerPayload_cid
import Split.BottNested_NestedCarriage_layers
import Split.Nat
import Split.BottNested_LayerPayload
import Split.Eq_refl
import Split.Prod
import Split.OfNat_ofNat
import Split.List_zipIdx
import Split.Eq
import Split.BottNested_NestedCarriage

-- BottNested.flatten.eq_1 from environment
-- theorem BottNested.flatten.eq_1 : forall (nc : BottNested.NestedCarriage), Eq.{1} (List.{0} MonsterTrain.CARBlock) (BottNested.flatten nc) (List.map.{0, 0} (Prod.{0, 0} BottNested.LayerPayload Nat) MonsterTrain.CARBlock (fun (x._@.RequestProject.BottNestedCarriage.2116375929._hygCtx._hyg.10 : Prod.{0, 0} BottNested.LayerPayload Nat) => BottNested.bottFold.match_1.{1} (fun (x._@.RequestProject.BottNestedCarriage.2116375929._hygCtx.10.RequestProject.BottNestedCarriage.2116375929._hygCtx._hyg.21 : Prod.{0, 0} BottNested.LayerPayload Nat) => MonsterTrain.CARBlock) x._@.RequestProject.BottNestedCarriage.2116375929._hygCtx._hyg.10 (fun (lp : BottNested.LayerPayload) (i : Nat) => MonsterTrain.CARBlock.mk (BottNested.LayerPayload.cid lp) (BottNested.LayerPayload.payload lp) (_private.RequestProject.BottNestedCarriage.0.BottNested.mkParent (BottNested.NestedCarriage.layers nc) i))) (List.zipIdx.{0} BottNested.LayerPayload (BottNested.NestedCarriage.layers nc) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))

-- Stub: this file represents the declaration `BottNested.flatten.eq_1`.
-- In a full split, the body would be extracted from the environment.
