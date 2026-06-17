import Split.String
import Split.UnifiedIPLDMemory_CARBlock
import Split.UnifiedIPLDMemory_CARBlock_mk
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.And
import Split.And_intro
import Split.UnifiedIPLDMemory_CARBlock_mk_noConfusion
import Split.Eq
import Split.UnifiedIPLDMemory_ABISpecies

-- UnifiedIPLDMemory.CARBlock.mk.inj from environment
-- theorem UnifiedIPLDMemory.CARBlock.mk.inj : forall {block : UnifiedIPLDMemory.IPLDBlock} {species : UnifiedIPLDMemory.ABISpecies} {vernacularName : String} {block_1 : UnifiedIPLDMemory.IPLDBlock} {species_1 : UnifiedIPLDMemory.ABISpecies} {vernacularName_1 : String}, (Eq.{1} UnifiedIPLDMemory.CARBlock (UnifiedIPLDMemory.CARBlock.mk block species vernacularName) (UnifiedIPLDMemory.CARBlock.mk block_1 species_1 vernacularName_1)) -> (And (Eq.{1} UnifiedIPLDMemory.IPLDBlock block block_1) (And (Eq.{1} UnifiedIPLDMemory.ABISpecies species species_1) (Eq.{1} String vernacularName vernacularName_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARBlock.mk.inj`.
-- In a full split, the body would be extracted from the environment.
