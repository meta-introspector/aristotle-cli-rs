import Split.UnifiedIPLDMemory_CARBlock_noConfusion
import Split.String
import Split.UnifiedIPLDMemory_CARBlock
import Split.UnifiedIPLDMemory_CARBlock_mk
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.id
import Split.Eq
import Split.UnifiedIPLDMemory_ABISpecies

-- UnifiedIPLDMemory.CARBlock.mk.noConfusion from environment
-- def UnifiedIPLDMemory.CARBlock.mk.noConfusion : forall {P : Sort.{u}} {block : UnifiedIPLDMemory.IPLDBlock} {species : UnifiedIPLDMemory.ABISpecies} {vernacularName : String} {block' : UnifiedIPLDMemory.IPLDBlock} {species' : UnifiedIPLDMemory.ABISpecies} {vernacularName' : String}, (Eq.{1} UnifiedIPLDMemory.CARBlock (UnifiedIPLDMemory.CARBlock.mk block species vernacularName) (UnifiedIPLDMemory.CARBlock.mk block' species' vernacularName')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDBlock block block') -> (Eq.{1} UnifiedIPLDMemory.ABISpecies species species') -> (Eq.{1} String vernacularName vernacularName') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARBlock.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
