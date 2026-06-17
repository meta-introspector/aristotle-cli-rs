import Split.PadicEntropyDAG_PartitionKey_mk
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.PadicEntropyDAG_PartitionKey

-- PadicEntropyDAG.PartitionKey.mk.sizeOf_spec from environment
-- theorem PadicEntropyDAG.PartitionKey.mk.sizeOf_spec : forall (stage1 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) (stage2 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) (stage3 : Nat) (irrep : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} PadicEntropyDAG.PartitionKey PadicEntropyDAG.PartitionKey._sizeOf_inst (PadicEntropyDAG.PartitionKey.mk stage1 stage2 stage3 irrep)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) (Prod._sizeOf_inst.{0, 0} Nat (Prod.{0, 0} Nat Nat) instSizeOfNat (Prod._sizeOf_inst.{0, 0} Nat Nat instSizeOfNat instSizeOfNat)) stage1)) (SizeOf.sizeOf.{1} (Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) (Prod._sizeOf_inst.{0, 0} Nat (Prod.{0, 0} Nat Nat) instSizeOfNat (Prod._sizeOf_inst.{0, 0} Nat Nat instSizeOfNat instSizeOfNat)) stage2)) (SizeOf.sizeOf.{1} Nat instSizeOfNat stage3)) (SizeOf.sizeOf.{1} Nat instSizeOfNat irrep))

-- Stub: this file represents the declaration `PadicEntropyDAG.PartitionKey.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
