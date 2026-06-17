import Split.UnifiedIPLDMemory_WebContentType
import Split.FiberedUniverse_S_ss
import Split.String
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.id
import Split.UnifiedIPLDMemory_WebTile_noConfusion
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebTile_mk
import Split.Eq

-- UnifiedIPLDMemory.WebTile.mk.noConfusion from environment
-- def UnifiedIPLDMemory.WebTile.mk.noConfusion : forall {P : Sort.{u}} {block : UnifiedIPLDMemory.IPLDBlock} {contentType : UnifiedIPLDMemory.WebContentType} {sourceURL : String} {fiberPoint : FiberedUniverse.S_ss} {block' : UnifiedIPLDMemory.IPLDBlock} {contentType' : UnifiedIPLDMemory.WebContentType} {sourceURL' : String} {fiberPoint' : FiberedUniverse.S_ss}, (Eq.{1} UnifiedIPLDMemory.WebTile (UnifiedIPLDMemory.WebTile.mk block contentType sourceURL fiberPoint) (UnifiedIPLDMemory.WebTile.mk block' contentType' sourceURL' fiberPoint')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDBlock block block') -> (Eq.{1} UnifiedIPLDMemory.WebContentType contentType contentType') -> (Eq.{1} String sourceURL sourceURL') -> (Eq.{1} FiberedUniverse.S_ss fiberPoint fiberPoint') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebTile.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
