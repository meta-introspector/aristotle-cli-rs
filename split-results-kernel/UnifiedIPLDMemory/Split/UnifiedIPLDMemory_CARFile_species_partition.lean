import Split.UnifiedIPLDMemory_CARFile_dwarvenCount
import Split.UnifiedIPLDMemory_CARFile
import Split.UnifiedIPLDMemory_CARBlock
import Split.UnifiedIPLDMemory_CARFile_carBlocks
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_CARFile_elvenCount

-- UnifiedIPLDMemory.CARFile.species_partition from environment
-- theorem UnifiedIPLDMemory.CARFile.species_partition : forall (self : UnifiedIPLDMemory.CARFile), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (UnifiedIPLDMemory.CARFile.elvenCount self) (UnifiedIPLDMemory.CARFile.dwarvenCount self)) (List.length.{0} UnifiedIPLDMemory.CARBlock (UnifiedIPLDMemory.CARFile.carBlocks self))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARFile.species_partition`.
-- In a full split, the body would be extracted from the environment.
