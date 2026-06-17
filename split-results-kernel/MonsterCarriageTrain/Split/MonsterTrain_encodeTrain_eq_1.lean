import Split.MonsterTrain_MonsterCarriageTrain_cars
import Split.List_map
import Split.HSub_hSub
import Split.MonsterTrain_CARBlock
import Split.Option_some
import Split.MonsterTrain_encodeTrain
import Split.instSubNat
import Split.instOfNatNat
import Split.MonsterTrain_CARBlock_mk
import Split.MonsterTrain_encodeTrain_match_1
import Split.Option_none
import Split.List
import Split.instHSub
import Split.Nat
import Split.MonsterTrain_Carriage_capacity
import Split.MonsterTrain_CID_mk
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.MonsterTrain_CID
import Split.Prod
import Split.OfNat_ofNat
import Split.List_zipIdx
import Split.Eq
import Split.MonsterTrain_MonsterCarriageTrain
import Split.MonsterTrain_Carriage
import Split.Option
import Split.ite

-- MonsterTrain.encodeTrain.eq_1 from environment
-- theorem MonsterTrain.encodeTrain.eq_1 : forall (t : MonsterTrain.MonsterCarriageTrain), Eq.{1} (List.{0} MonsterTrain.CARBlock) (MonsterTrain.encodeTrain t) (List.map.{0, 0} (Prod.{0, 0} MonsterTrain.Carriage Nat) MonsterTrain.CARBlock (fun (x._@.RequestProject.MonsterCarriageTrain.1752126947._hygCtx._hyg.10 : Prod.{0, 0} MonsterTrain.Carriage Nat) => MonsterTrain.encodeTrain.match_1.{1} (fun (x._@.RequestProject.MonsterCarriageTrain.1752126947._hygCtx.10.RequestProject.MonsterCarriageTrain.1752126947._hygCtx._hyg.21 : Prod.{0, 0} MonsterTrain.Carriage Nat) => MonsterTrain.CARBlock) x._@.RequestProject.MonsterCarriageTrain.1752126947._hygCtx._hyg.10 (fun (c : MonsterTrain.Carriage) (i : Nat) => MonsterTrain.CARBlock.mk (MonsterTrain.CID.mk i) (MonsterTrain.Carriage.capacity c) (ite.{1} (Option.{0} MonsterTrain.CID) (Eq.{1} Nat i (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (instDecidableEqNat i (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.none.{0} MonsterTrain.CID) (Option.some.{0} MonsterTrain.CID (MonsterTrain.CID.mk (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))))) (List.zipIdx.{0} MonsterTrain.Carriage (MonsterTrain.MonsterCarriageTrain.cars t) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))

-- Stub: this file represents the declaration `MonsterTrain.encodeTrain.eq_1`.
-- In a full split, the body would be extracted from the environment.
