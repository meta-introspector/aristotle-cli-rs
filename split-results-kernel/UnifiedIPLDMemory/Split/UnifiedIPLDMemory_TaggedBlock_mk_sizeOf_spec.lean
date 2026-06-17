import Split.UnifiedIPLDMemory_TaggedBlock_mk
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Prod_mk
import Split.instOfNatNat
import Split.ZMod
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.UnifiedIPLDMemory_MemorySubsystem
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.TaggedBlock.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.TaggedBlock.mk.sizeOf_spec : forall (block : UnifiedIPLDMemory.IPLDBlock) (origin : UnifiedIPLDMemory.MemorySubsystem) (fiberPoint : FiberedUniverse.S_ss) (residue71 : ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (residue59 : ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (residue47 : ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (residue_consistent : Eq.{1} FiberedUniverse.S_ss fiberPoint (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue71 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue59 residue47))), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.TaggedBlock UnifiedIPLDMemory.TaggedBlock._sizeOf_inst (UnifiedIPLDMemory.TaggedBlock.mk block origin fiberPoint residue71 residue59 residue47 residue_consistent)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDBlock UnifiedIPLDMemory.IPLDBlock._sizeOf_inst block)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.MemorySubsystem UnifiedIPLDMemory.MemorySubsystem._sizeOf_inst origin)) (SizeOf.sizeOf.{1} FiberedUniverse.S_ss (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))))) fiberPoint)) (SizeOf.sizeOf.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) residue71)) (SizeOf.sizeOf.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)))) residue59)) (SizeOf.sizeOf.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue47)) (SizeOf.sizeOf.{0} (Eq.{1} FiberedUniverse.S_ss fiberPoint (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue71 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue59 residue47))) (instSizeOfDefault.{0} (Eq.{1} FiberedUniverse.S_ss fiberPoint (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) residue71 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) residue59 residue47)))) residue_consistent))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.TaggedBlock.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
