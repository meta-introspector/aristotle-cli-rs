import Split.UnifiedIPLDMemory_TaggedBlock_mk
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Prod_mk
import Split.instOfNatNat
import Split.ZMod
import Split.Nat
import Split.UnifiedIPLDMemory_MemorySubsystem
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.TaggedBlock.rec from environment
-- recursor UnifiedIPLDMemory.TaggedBlock.rec : forall {motive : UnifiedIPLDMemory.TaggedBlock -> Sort.{u}}, (forall (block : UnifiedIPLDMemory.IPLDBlock) (origin : UnifiedIPLDMemory.MemorySubsystem) (fiberPoint : FiberedUniverse.S_ss) (residue71 : ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (residue59 : ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (residue47 : ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (residue_consistent : Eq.{1} FiberedUniverse.S_ss fiberPoint (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue71 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue59 residue47))), motive (UnifiedIPLDMemory.TaggedBlock.mk block origin fiberPoint residue71 residue59 residue47 residue_consistent)) -> (forall (t : UnifiedIPLDMemory.TaggedBlock), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.TaggedBlock.rec`.
-- In a full split, the body would be extracted from the environment.
