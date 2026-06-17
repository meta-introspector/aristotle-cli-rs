import Split.Eq_mpr
import Split.congrArg
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.id
import Split.Ne
import Split.Ne_symm
import Split.Eq

-- UnifiedIPLDMemory.no_cross_fiber_ingest from environment
-- theorem UnifiedIPLDMemory.no_cross_fiber_ingest : forall (x : FiberedUniverse.S_ss) (y : FiberedUniverse.S_ss), (Ne.{1} FiberedUniverse.S_ss x y) -> (forall (tb : UnifiedIPLDMemory.TaggedBlock), (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) y) -> (Ne.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.no_cross_fiber_ingest`.
-- In a full split, the body would be extracted from the environment.
