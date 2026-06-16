import Split.String
import Split.UnifiedIPLDMemory_CARBlock
import Split.UnifiedIPLDMemory_CARBlock_mk
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.UnifiedIPLDMemory_ABISpecies

-- UnifiedIPLDMemory.CARBlock.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.CARBlock.mk.sizeOf_spec : forall (block : UnifiedIPLDMemory.IPLDBlock) (species : UnifiedIPLDMemory.ABISpecies) (vernacularName : String), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.CARBlock UnifiedIPLDMemory.CARBlock._sizeOf_inst (UnifiedIPLDMemory.CARBlock.mk block species vernacularName)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDBlock UnifiedIPLDMemory.IPLDBlock._sizeOf_inst block)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.ABISpecies UnifiedIPLDMemory.ABISpecies._sizeOf_inst species)) (SizeOf.sizeOf.{1} String String._sizeOf_inst vernacularName))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.CARBlock.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
