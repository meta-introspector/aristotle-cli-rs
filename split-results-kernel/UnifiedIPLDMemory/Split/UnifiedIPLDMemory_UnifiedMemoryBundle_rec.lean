import Split.UnifiedIPLDMemory_MemoryFiber_blocks
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle_mk
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMemoryBundle.rec from environment
-- recursor UnifiedIPLDMemory.UnifiedMemoryBundle.rec : forall {motive : UnifiedIPLDMemory.UnifiedMemoryBundle -> Sort.{u}}, (forall (fiber : forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x) (coherence : forall (x : FiberedUniverse.S_ss) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x (fiber x)) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)), motive (UnifiedIPLDMemory.UnifiedMemoryBundle.mk fiber coherence)) -> (forall (t : UnifiedIPLDMemory.UnifiedMemoryBundle), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryBundle.rec`.
-- In a full split, the body would be extracted from the environment.
