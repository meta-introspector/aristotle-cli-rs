import Split.Eq_propIntro
import Split.UnifiedIPLDMemory_CARFile
import Split.UnifiedIPLDMemory_CARBlock
import Split.Lean_injEq_helper
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_CARFile_mk_inj
import Split.UnifiedIPLDMemory_CARFile_mk
import Split.List
import Split.instHAdd
import Split.And
import Split.HAdd_hAdd
import Split.Nat
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.CARFile.mk.injEq from environment
-- theorem UnifiedIPLDMemory.CARFile.mk.injEq : forall (rootCID : UnifiedIPLDMemory.IPLDCID) (carBlocks : List.{0} UnifiedIPLDMemory.CARBlock) (elvenCount : Nat) (dwarvenCount : Nat) (species_partition : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount dwarvenCount) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks)) (rootCID_1 : UnifiedIPLDMemory.IPLDCID) (carBlocks_1 : List.{0} UnifiedIPLDMemory.CARBlock) (elvenCount_1 : Nat) (dwarvenCount_1 : Nat) (species_partition_1 : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount_1 dwarvenCount_1) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks_1)), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.CARFile (UnifiedIPLDMemory.CARFile.mk rootCID carBlocks elvenCount dwarvenCount species_partition) (UnifiedIPLDMemory.CARFile.mk rootCID_1 carBlocks_1 elvenCount_1 dwarvenCount_1 species_partition_1)) (And (Eq.{1} UnifiedIPLDMemory.IPLDCID rootCID rootCID_1) (And (Eq.{1} (List.{0} UnifiedIPLDMemory.CARBlock) carBlocks carBlocks_1) (And (Eq.{1} Nat elvenCount elvenCount_1) (Eq.{1} Nat dwarvenCount dwarvenCount_1))))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARFile.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
