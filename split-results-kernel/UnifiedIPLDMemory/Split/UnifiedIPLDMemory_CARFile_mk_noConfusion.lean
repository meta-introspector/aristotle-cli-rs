import Split.UnifiedIPLDMemory_CARFile
import Split.UnifiedIPLDMemory_CARBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.id
import Split.UnifiedIPLDMemory_CARFile_mk
import Split.List
import Split.instHAdd
import Split.UnifiedIPLDMemory_CARFile_noConfusion
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.CARFile.mk.noConfusion from environment
-- def UnifiedIPLDMemory.CARFile.mk.noConfusion : forall {P : Sort.{u}} {rootCID : UnifiedIPLDMemory.IPLDCID} {carBlocks : List.{0} UnifiedIPLDMemory.CARBlock} {elvenCount : Nat} {dwarvenCount : Nat} {species_partition : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount dwarvenCount) (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks)} {rootCID' : UnifiedIPLDMemory.IPLDCID} {carBlocks' : List.{0} UnifiedIPLDMemory.CARBlock} {elvenCount' : Nat} {dwarvenCount' : Nat} {species_partition' : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) elvenCount' dwarvenCount') (List.length.{0} UnifiedIPLDMemory.CARBlock carBlocks')}, (Eq.{1} UnifiedIPLDMemory.CARFile (UnifiedIPLDMemory.CARFile.mk rootCID carBlocks elvenCount dwarvenCount species_partition) (UnifiedIPLDMemory.CARFile.mk rootCID' carBlocks' elvenCount' dwarvenCount' species_partition')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDCID rootCID rootCID') -> (Eq.{1} (List.{0} UnifiedIPLDMemory.CARBlock) carBlocks carBlocks') -> (Eq.{1} Nat elvenCount elvenCount') -> (Eq.{1} Nat dwarvenCount dwarvenCount') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARFile.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
