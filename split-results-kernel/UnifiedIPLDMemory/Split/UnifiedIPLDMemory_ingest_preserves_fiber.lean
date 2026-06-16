import Split.UnifiedIPLDMemory_MemoryFiber_blocks
import Split.FiberedUniverse_S_ss
import Split.HEq_refl
import Split.List_Mem_tail
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.List_instMembership
import Split.List_Mem_head
import Split.eq_of_heq
import Split.Eq_ndrec
import Split.UnifiedIPLDMemory_MemoryFiber_all_at_base
import Split.Eq_refl
import Split.HEq
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.List_Mem
import Split.UnifiedIPLDMemory_passesGate
import Split.Eq
import Split.List_Mem_casesOn
import Split.List_cons_noConfusion

-- UnifiedIPLDMemory.ingest_preserves_fiber from environment
-- theorem UnifiedIPLDMemory.ingest_preserves_fiber : forall (x : FiberedUniverse.S_ss) (mf : UnifiedIPLDMemory.MemoryFiber x) (tb : UnifiedIPLDMemory.TaggedBlock), (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x) -> (UnifiedIPLDMemory.passesGate tb) -> (forall (tb' : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (List.cons.{0} UnifiedIPLDMemory.TaggedBlock tb (UnifiedIPLDMemory.MemoryFiber.blocks x mf)) tb') -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb') x))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.ingest_preserves_fiber`.
-- In a full split, the body would be extracted from the environment.
