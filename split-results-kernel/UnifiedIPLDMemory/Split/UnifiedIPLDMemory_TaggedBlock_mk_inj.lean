import Split.UnifiedIPLDMemory_TaggedBlock_mk_noConfusion
import Split.UnifiedIPLDMemory_TaggedBlock_mk
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Prod_mk
import Split.instOfNatNat
import Split.ZMod
import Split.And
import Split.Nat
import Split.And_intro
import Split.UnifiedIPLDMemory_MemorySubsystem
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.TaggedBlock.mk.inj from environment
-- theorem UnifiedIPLDMemory.TaggedBlock.mk.inj : forall {block : UnifiedIPLDMemory.IPLDBlock} {origin : UnifiedIPLDMemory.MemorySubsystem} {fiberPoint : FiberedUniverse.S_ss} {residue71 : ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))} {residue59 : ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))} {residue47 : ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))} {residue_consistent : Eq.{1} FiberedUniverse.S_ss fiberPoint (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue71 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue59 residue47))} {block_1 : UnifiedIPLDMemory.IPLDBlock} {origin_1 : UnifiedIPLDMemory.MemorySubsystem} {fiberPoint_1 : FiberedUniverse.S_ss} {residue71_1 : ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))} {residue59_1 : ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))} {residue47_1 : ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))} {residue_consistent_1 : Eq.{1} FiberedUniverse.S_ss fiberPoint_1 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue71_1 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue59_1 residue47_1))}, (Eq.{1} UnifiedIPLDMemory.TaggedBlock (UnifiedIPLDMemory.TaggedBlock.mk block origin fiberPoint residue71 residue59 residue47 residue_consistent) (UnifiedIPLDMemory.TaggedBlock.mk block_1 origin_1 fiberPoint_1 residue71_1 residue59_1 residue47_1 residue_consistent_1)) -> (And (Eq.{1} UnifiedIPLDMemory.IPLDBlock block block_1) (And (Eq.{1} UnifiedIPLDMemory.MemorySubsystem origin origin_1) (And (Eq.{1} FiberedUniverse.S_ss fiberPoint fiberPoint_1) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) residue71 residue71_1) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) residue59 residue59_1) (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue47 residue47_1))))))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.TaggedBlock.mk.inj`.
-- In a full split, the body would be extracted from the environment.
