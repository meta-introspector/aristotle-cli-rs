import Split.UnifiedIPLDMemory_WebContentType
import Split.FiberedUniverse_S_ss
import Split.String
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_WebTile
import Split.instOfNatNat
import Split.ZMod
import Split.UnifiedIPLDMemory_WebTile_mk
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.WebTile.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.WebTile.mk.sizeOf_spec : forall (block : UnifiedIPLDMemory.IPLDBlock) (contentType : UnifiedIPLDMemory.WebContentType) (sourceURL : String) (fiberPoint : FiberedUniverse.S_ss), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.WebTile UnifiedIPLDMemory.WebTile._sizeOf_inst (UnifiedIPLDMemory.WebTile.mk block contentType sourceURL fiberPoint)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDBlock UnifiedIPLDMemory.IPLDBlock._sizeOf_inst block)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.WebContentType UnifiedIPLDMemory.WebContentType._sizeOf_inst contentType)) (SizeOf.sizeOf.{1} String String._sizeOf_inst sourceURL)) (SizeOf.sizeOf.{1} FiberedUniverse.S_ss (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))))) fiberPoint))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebTile.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
