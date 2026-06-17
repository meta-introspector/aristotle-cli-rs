import Split.instOfNatNat
import Split.BottNested_LayerPayload_mk
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.BottNested_LayerPayload
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq

-- BottNested.LayerPayload.mk.sizeOf_spec from environment
-- theorem BottNested.LayerPayload.mk.sizeOf_spec : forall (cid : MonsterTrain.CID) (payload : Nat) (layer : Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), Eq.{1} Nat (SizeOf.sizeOf.{1} BottNested.LayerPayload BottNested.LayerPayload._sizeOf_inst (BottNested.LayerPayload.mk cid payload layer)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} MonsterTrain.CID MonsterTrain.CID._sizeOf_inst cid)) (SizeOf.sizeOf.{1} Nat instSizeOfNat payload)) (SizeOf.sizeOf.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Fin._sizeOf_inst (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) layer))

-- Stub: this file represents the declaration `BottNested.LayerPayload.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
