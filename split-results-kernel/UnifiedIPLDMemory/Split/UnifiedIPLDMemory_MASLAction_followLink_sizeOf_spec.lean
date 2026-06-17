import Split.UnifiedIPLDMemory_MASLAction_followLink
import Split.UnifiedIPLDMemory_MASLAction
import Split.UnifiedIPLDMemory_IPLDCID
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.MASLAction.followLink.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.MASLAction.followLink.sizeOf_spec : forall (targetCID : UnifiedIPLDMemory.IPLDCID), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.MASLAction UnifiedIPLDMemory.MASLAction._sizeOf_inst (UnifiedIPLDMemory.MASLAction.followLink targetCID)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst targetCID))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MASLAction.followLink.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
