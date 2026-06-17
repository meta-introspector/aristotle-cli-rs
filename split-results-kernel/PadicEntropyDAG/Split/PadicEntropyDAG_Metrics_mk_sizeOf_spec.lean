import Split.PadicEntropyDAG_Metrics
import Split.Float
import Split.instOfNatNat
import Split.PadicEntropyDAG_Metrics_mk
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq

-- PadicEntropyDAG.Metrics.mk.sizeOf_spec from environment
-- theorem PadicEntropyDAG.Metrics.mk.sizeOf_spec : forall (sum : Nat) (logsum : Float) (bits : Float) (trits : Float), Eq.{1} Nat (SizeOf.sizeOf.{1} PadicEntropyDAG.Metrics PadicEntropyDAG.Metrics._sizeOf_inst (PadicEntropyDAG.Metrics.mk sum logsum bits trits)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat sum)) (SizeOf.sizeOf.{1} Float Float._sizeOf_inst logsum)) (SizeOf.sizeOf.{1} Float Float._sizeOf_inst bits)) (SizeOf.sizeOf.{1} Float Float._sizeOf_inst trits))

-- Stub: this file represents the declaration `PadicEntropyDAG.Metrics.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
