import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.List_instMembership
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.OfNat_ofNat
import Split.Eq
import Split.UnifiedIPLDMemory_MemoryFiber_mk

-- UnifiedIPLDMemory.MemoryFiber.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.MemoryFiber.mk.sizeOf_spec : forall {x : FiberedUniverse.S_ss} (blocks : List.{0} UnifiedIPLDMemory.TaggedBlock) (all_at_base : forall (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) blocks tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)), Eq.{1} Nat (SizeOf.sizeOf.{1} (UnifiedIPLDMemory.MemoryFiber x) (UnifiedIPLDMemory.MemoryFiber._sizeOf_inst x) (UnifiedIPLDMemory.MemoryFiber.mk x blocks all_at_base)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} UnifiedIPLDMemory.TaggedBlock) (List._sizeOf_inst.{0} UnifiedIPLDMemory.TaggedBlock UnifiedIPLDMemory.TaggedBlock._sizeOf_inst) blocks))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MemoryFiber.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
