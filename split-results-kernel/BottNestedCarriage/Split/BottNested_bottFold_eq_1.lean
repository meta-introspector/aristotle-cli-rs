import Split.BottNested_NestedCarriage_mk
import Split.List_map
import Split.Fin_mk
import Split.BottNested_bottFold_match_1
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk
import Split.HMod_hMod
import Split.BottNested_LayerPayload_payload
import Split.BottNested_LayerPayload_cid
import Split.BottNested_NestedCarriage_layers
import Split.Nat
import Split.BottNested_LayerPayload
import Split.Eq_refl
import Split.BottNested_bottFold
import Split.Prod
import Split.OfNat_ofNat
import Split.List_zipIdx
import Split.Eq
import Split.BottNested_NestedCarriage

-- BottNested.bottFold.eq_1 from environment
-- theorem BottNested.bottFold.eq_1 : forall (nc : BottNested.NestedCarriage), Eq.{1} BottNested.NestedCarriage (BottNested.bottFold nc) (BottNested.NestedCarriage.mk (List.map.{0, 0} (Prod.{0, 0} BottNested.LayerPayload Nat) BottNested.LayerPayload (fun (x._@.RequestProject.BottNestedCarriage.2640416363._hygCtx._hyg.11 : Prod.{0, 0} BottNested.LayerPayload Nat) => BottNested.bottFold.match_1.{1} (fun (x._@.RequestProject.BottNestedCarriage.2640416363._hygCtx.11.RequestProject.BottNestedCarriage.2640416363._hygCtx._hyg.22 : Prod.{0, 0} BottNested.LayerPayload Nat) => BottNested.LayerPayload) x._@.RequestProject.BottNestedCarriage.2640416363._hygCtx._hyg.11 (fun (lp : BottNested.LayerPayload) (i : Nat) => BottNested.LayerPayload.mk (BottNested.LayerPayload.cid lp) (BottNested.LayerPayload.payload lp) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) i (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BottNested.bottFold._proof_1 i)))) (List.zipIdx.{0} BottNested.LayerPayload (BottNested.NestedCarriage.layers nc) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))))

-- Stub: this file represents the declaration `BottNested.bottFold.eq_1`.
-- In a full split, the body would be extracted from the environment.
