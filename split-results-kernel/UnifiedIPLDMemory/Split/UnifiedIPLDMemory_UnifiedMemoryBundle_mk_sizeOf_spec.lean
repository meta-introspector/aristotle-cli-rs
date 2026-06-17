import Split.UnifiedIPLDMemory_MemoryFiber_blocks
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.SizeOf_sizeOf
import Split.Eq_refl
import Split.UnifiedIPLDMemory_UnifiedMemoryBundle_mk
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMemoryBundle.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.UnifiedMemoryBundle.mk.sizeOf_spec : forall (fiber : forall (x : FiberedUniverse.S_ss), UnifiedIPLDMemory.MemoryFiber x) (coherence : forall (x : FiberedUniverse.S_ss) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x (fiber x)) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.UnifiedMemoryBundle UnifiedIPLDMemory.UnifiedMemoryBundle._sizeOf_inst (UnifiedIPLDMemory.UnifiedMemoryBundle.mk fiber coherence)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryBundle.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
