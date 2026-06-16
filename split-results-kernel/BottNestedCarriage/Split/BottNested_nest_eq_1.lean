import Split.BottNested_NestedCarriage_mk
import Split.Fin_mk
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk
import Split.BottNested_nest
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.HMod_hMod
import Split.BottNested_NestedCarriage_layers
import Split.Nat
import Split.BottNested_LayerPayload
import Split.Eq_refl
import Split.MonsterTrain_CID
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.BottNested_NestedCarriage
import Split.List_nil

-- BottNested.nest.eq_1 from environment
-- theorem BottNested.nest.eq_1 : forall (nc : BottNested.NestedCarriage) (cid : MonsterTrain.CID) (payload : Nat), Eq.{1} BottNested.NestedCarriage (BottNested.nest nc cid payload) (BottNested.NestedCarriage.mk (HAppend.hAppend.{0, 0, 0} (List.{0} BottNested.LayerPayload) (List.{0} BottNested.LayerPayload) (List.{0} BottNested.LayerPayload) (instHAppendOfAppend.{0} (List.{0} BottNested.LayerPayload) (List.instAppend.{0} BottNested.LayerPayload)) (BottNested.NestedCarriage.layers nc) (List.cons.{0} BottNested.LayerPayload (BottNested.LayerPayload.mk cid payload (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (List.length.{0} BottNested.LayerPayload (BottNested.NestedCarriage.layers nc)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BottNested.nest._proof_2 nc))) (List.nil.{0} BottNested.LayerPayload))))

-- Stub: this file represents the declaration `BottNested.nest.eq_1`.
-- In a full split, the body would be extracted from the environment.
