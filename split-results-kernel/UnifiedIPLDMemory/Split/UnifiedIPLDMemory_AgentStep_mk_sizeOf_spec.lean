import Split.UnifiedIPLDMemory_MASLAction
import Split.UnifiedIPLDMemory_WebTile
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.UnifiedIPLDMemory_AgentStep_mk
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.UnifiedIPLDMemory_AgentStep
import Split.Eq

-- UnifiedIPLDMemory.AgentStep.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.AgentStep.mk.sizeOf_spec : forall (currentTile : UnifiedIPLDMemory.WebTile) (action : UnifiedIPLDMemory.MASLAction) (resultTile : UnifiedIPLDMemory.WebTile), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.AgentStep UnifiedIPLDMemory.AgentStep._sizeOf_inst (UnifiedIPLDMemory.AgentStep.mk currentTile action resultTile)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.WebTile UnifiedIPLDMemory.WebTile._sizeOf_inst currentTile)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.MASLAction UnifiedIPLDMemory.MASLAction._sizeOf_inst action)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.WebTile UnifiedIPLDMemory.WebTile._sizeOf_inst resultTile))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.AgentStep.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
