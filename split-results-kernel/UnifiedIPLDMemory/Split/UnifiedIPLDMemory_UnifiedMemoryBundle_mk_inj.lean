import Split.UnifiedIPLDMemory_MemoryFiber_blocks
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle_mk_noConfusion
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle_mk
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMemoryBundle.mk.inj from environment
-- theorem UnifiedIPLDMemory.UnifiedMemoryBundle.mk.inj : forall {fiber : forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x} {coherence : forall (x : FiberedUniverse.S_ss) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x (fiber x)) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)} {fiber_1 : forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x} {coherence_1 : forall (x : FiberedUniverse.S_ss) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x (fiber_1 x)) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)}, (Eq.{1} UnifiedIPLDMemory.UnifiedMemoryBundle (UnifiedIPLDMemory.UnifiedMemoryBundle.mk fiber coherence) (UnifiedIPLDMemory.UnifiedMemoryBundle.mk fiber_1 coherence_1)) -> (Eq.{1} (forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x) fiber fiber_1)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryBundle.mk.inj`.
-- In a full split, the body would be extracted from the environment.
