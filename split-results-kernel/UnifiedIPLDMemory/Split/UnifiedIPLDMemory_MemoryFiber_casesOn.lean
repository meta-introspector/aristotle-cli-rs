import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_MemoryFiber_rec
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq
import Split.UnifiedIPLDMemory_MemoryFiber_mk

-- UnifiedIPLDMemory.MemoryFiber.casesOn from environment
-- def UnifiedIPLDMemory.MemoryFiber.casesOn : forall {x : FiberedUniverse.S_ss} {motive : (UnifiedIPLDMemory.MemoryFiber x) -> Sort.{u}} (t : UnifiedIPLDMemory.MemoryFiber x), (forall (blocks : List.{0} UnifiedIPLDMemory.TaggedBlock) (all_at_base : forall (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) blocks tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)), motive (UnifiedIPLDMemory.MemoryFiber.mk x blocks all_at_base)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MemoryFiber.casesOn`.
-- In a full split, the body would be extracted from the environment.
