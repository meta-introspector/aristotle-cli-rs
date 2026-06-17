import Split.BottNested_NestedCarriage_mk
import Split.Fin_instOfNat
import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk
import Split.List_cons
import Split.BottNested_NestedCarriage_single
import Split.Nat
import Split.BottNested_LayerPayload
import Split.Eq_refl
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.BottNested_NestedCarriage
import Split.List_nil

-- BottNested.NestedCarriage.single.eq_1 from environment
-- theorem BottNested.NestedCarriage.single.eq_1 : forall (cid : MonsterTrain.CID) (payload : Nat), Eq.{1} BottNested.NestedCarriage (BottNested.NestedCarriage.single cid payload) (BottNested.NestedCarriage.mk (List.cons.{0} BottNested.LayerPayload (BottNested.LayerPayload.mk cid payload (OfNat.ofNat.{0} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) 0 (Fin.instOfNat (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) BottNested.NestedCarriage.single._proof_1 0))) (List.nil.{0} BottNested.LayerPayload)))

-- Stub: this file represents the declaration `BottNested.NestedCarriage.single.eq_1`.
-- In a full split, the body would be extracted from the environment.
