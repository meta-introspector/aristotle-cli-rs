import Split.UnifiedIPLDMemory_metaTickN
import Split.UnifiedIPLDMemory_UnifiedMetaTower
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_UnifiedMetaTower_mk
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMetaTower.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.UnifiedMetaTower.mk.sizeOf_spec : forall (base : UnifiedIPLDMemory.UnifiedMemoryState) (seq : Nat -> UnifiedIPLDMemory.UnifiedMemoryState) (compat : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq n) (UnifiedIPLDMemory.metaTickN n base)), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.UnifiedMetaTower UnifiedIPLDMemory.UnifiedMetaTower._sizeOf_inst (UnifiedIPLDMemory.UnifiedMetaTower.mk base seq compat)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.UnifiedMemoryState UnifiedIPLDMemory.UnifiedMemoryState._sizeOf_inst base))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMetaTower.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
