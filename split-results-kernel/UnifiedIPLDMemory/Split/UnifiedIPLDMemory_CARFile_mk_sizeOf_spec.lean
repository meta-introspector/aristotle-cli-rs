import Split.UnifiedIPLDMemory_CARFile
import Split.UnifiedIPLDMemory_CARBlock
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_IPLDCID
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_CARFile_mk
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.CARFile.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.CARFile.mk.sizeOf_spec : forall (rootCID : UnifiedIPLDMemory.IPLDCID) (carBlocks : List.{0} UnifiedIPLDMemory.CARBlock) (elvenCount : Nat) (dwarvenCount : Nat) (species_partition : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount dwarvenCount) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks)), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.CARFile UnifiedIPLDMemory.CARFile._sizeOf_inst (UnifiedIPLDMemory.CARFile.mk rootCID carBlocks elvenCount dwarvenCount species_partition)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst rootCID)) (SizeOf.sizeOf.{1} (List.{0} UnifiedIPLDMemory.CARBlock) (List._sizeOf_inst.{0} UnifiedIPLDMemory.CARBlock UnifiedIPLDMemory.CARBlock._sizeOf_inst) carBlocks)) (SizeOf.sizeOf.{1} Nat instSizeOfNat elvenCount)) (SizeOf.sizeOf.{1} Nat instSizeOfNat dwarvenCount)) (SizeOf.sizeOf.{0} (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount dwarvenCount) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks)) (instSizeOfDefault.{0} (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount dwarvenCount) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks))) species_partition))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARFile.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
