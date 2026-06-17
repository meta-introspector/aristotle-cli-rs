import Split.UnifiedIPLDMemory_CARFile
import Split.UnifiedIPLDMemory_CARBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_CARFile_mk
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.CARFile.rec from environment
-- recursor UnifiedIPLDMemory.CARFile.rec : forall {motive : UnifiedIPLDMemory.CARFile -> Sort.{u}}, (forall (rootCID : UnifiedIPLDMemory.IPLDCID) (carBlocks : List.{0} UnifiedIPLDMemory.CARBlock) (elvenCount : Nat) (dwarvenCount : Nat) (species_partition : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount dwarvenCount) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks)), motive (UnifiedIPLDMemory.CARFile.mk rootCID carBlocks elvenCount dwarvenCount species_partition)) -> (forall (t : UnifiedIPLDMemory.CARFile), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARFile.rec`.
-- In a full split, the body would be extracted from the environment.
