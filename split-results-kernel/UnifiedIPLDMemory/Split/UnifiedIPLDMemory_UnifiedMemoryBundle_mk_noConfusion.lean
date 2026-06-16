import Split.UnifiedIPLDMemory_MemoryFiber_blocks
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle_noConfusion
import Split.Membership_mem
import Split.id
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle_mk
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMemoryBundle.mk.noConfusion from environment
-- def UnifiedIPLDMemory.UnifiedMemoryBundle.mk.noConfusion : forall {P : Sort.{u}} {fiber : forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x} {coherence : forall (x : FiberedUniverse.S_ss) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x (fiber x)) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)} {fiber' : forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x} {coherence' : forall (x : FiberedUniverse.S_ss) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x (fiber' x)) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)}, (Eq.{1} UnifiedIPLDMemory.UnifiedMemoryBundle (UnifiedIPLDMemory.UnifiedMemoryBundle.mk fiber coherence) (UnifiedIPLDMemory.UnifiedMemoryBundle.mk fiber' coherence')) -> ((Eq.{1} (forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x) fiber fiber') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryBundle.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
