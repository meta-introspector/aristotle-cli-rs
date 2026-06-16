import Split.UnifiedIPLDMemory_WebContentType
import Split.FiberedUniverse_S_ss
import Split.String
import Split.UnifiedIPLDMemory_WebTile_mk_noConfusion
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebTile_mk
import Split.And
import Split.And_intro
import Split.Eq

-- UnifiedIPLDMemory.WebTile.mk.inj from environment
-- theorem UnifiedIPLDMemory.WebTile.mk.inj : forall {block : UnifiedIPLDMemory.IPLDBlock} {contentType : UnifiedIPLDMemory.WebContentType} {sourceURL : String} {fiberPoint : FiberedUniverse.S_ss} {block_1 : UnifiedIPLDMemory.IPLDBlock} {contentType_1 : UnifiedIPLDMemory.WebContentType} {sourceURL_1 : String} {fiberPoint_1 : FiberedUniverse.S_ss}, (Eq.{1} UnifiedIPLDMemory.WebTile (UnifiedIPLDMemory.WebTile.mk block contentType sourceURL fiberPoint) (UnifiedIPLDMemory.WebTile.mk block_1 contentType_1 sourceURL_1 fiberPoint_1)) -> (And (Eq.{1} UnifiedIPLDMemory.IPLDBlock block block_1) (And (Eq.{1} UnifiedIPLDMemory.WebContentType contentType contentType_1) (And (Eq.{1} String sourceURL sourceURL_1) (Eq.{1} FiberedUniverse.S_ss fiberPoint fiberPoint_1))))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebTile.mk.inj`.
-- In a full split, the body would be extracted from the environment.
