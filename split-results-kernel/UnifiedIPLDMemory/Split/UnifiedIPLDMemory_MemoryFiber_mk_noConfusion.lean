import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.id
import Split.List
import Split.heq_of_eq
import Split.UnifiedIPLDMemory_MemoryFiber_noConfusion
import Split.List_instMembership
import Split.Eq_refl
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq
import Split.UnifiedIPLDMemory_MemoryFiber_mk

-- UnifiedIPLDMemory.MemoryFiber.mk.noConfusion from environment
-- def UnifiedIPLDMemory.MemoryFiber.mk.noConfusion : forall {x : FiberedUniverse.S_ss} {P : Sort.{u}} {blocks : List.{0} UnifiedIPLDMemory.TaggedBlock} {all_at_base : forall (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) blocks tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)} {blocks' : List.{0} UnifiedIPLDMemory.TaggedBlock} {all_at_base' : forall (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) blocks' tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)}, (Eq.{1} (UnifiedIPLDMemory.MemoryFiber x) (UnifiedIPLDMemory.MemoryFiber.mk x blocks all_at_base) (UnifiedIPLDMemory.MemoryFiber.mk x blocks' all_at_base')) -> ((Eq.{1} (List.{0} UnifiedIPLDMemory.TaggedBlock) blocks blocks') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MemoryFiber.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
