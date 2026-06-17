import Split.BottNested_NestedCarriage_mk
import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.BottNested_LayerPayload
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.BottNested_NestedCarriage

-- BottNested.NestedCarriage.mk.sizeOf_spec from environment
-- theorem BottNested.NestedCarriage.mk.sizeOf_spec : forall (layers : List.{0} BottNested.LayerPayload), Eq.{1} Nat (SizeOf.sizeOf.{1} BottNested.NestedCarriage BottNested.NestedCarriage._sizeOf_inst (BottNested.NestedCarriage.mk layers)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} BottNested.LayerPayload) (List._sizeOf_inst.{0} BottNested.LayerPayload BottNested.LayerPayload._sizeOf_inst) layers))

-- Stub: this file represents the declaration `BottNested.NestedCarriage.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
