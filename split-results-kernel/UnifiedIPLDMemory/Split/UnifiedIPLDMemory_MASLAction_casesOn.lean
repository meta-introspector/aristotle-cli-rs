import Split.UnifiedIPLDMemory_MASLAction_rec
import Split.UnifiedIPLDMemory_MASLAction_followLink
import Split.UnifiedIPLDMemory_MASLAction
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_MASLAction_liftToProof
import Split.List
import Split.UnifiedIPLDMemory_MASLAction_queryCSS
import Split.UnifiedIPLDMemory_MASLAction_enterJSRealm
import Split.Nat
import Split.UnifiedIPLDMemory_MASLAction_compressRegion

-- UnifiedIPLDMemory.MASLAction.casesOn from environment
-- def UnifiedIPLDMemory.MASLAction.casesOn : forall {motive : UnifiedIPLDMemory.MASLAction -> Sort.{u}} (t : UnifiedIPLDMemory.MASLAction), (forall (targetCID : UnifiedIPLDMemory.IPLDCID), motive (UnifiedIPLDMemory.MASLAction.followLink targetCID)) -> (forall (moduleCID : UnifiedIPLDMemory.IPLDCID), motive (UnifiedIPLDMemory.MASLAction.enterJSRealm moduleCID)) -> (forall (tileCID : UnifiedIPLDMemory.IPLDCID), motive (UnifiedIPLDMemory.MASLAction.liftToProof tileCID)) -> (forall (tileCIDs : List.{0} UnifiedIPLDMemory.IPLDCID), motive (UnifiedIPLDMemory.MASLAction.compressRegion tileCIDs)) -> (forall (selectorHash : Nat), motive (UnifiedIPLDMemory.MASLAction.queryCSS selectorHash)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MASLAction.casesOn`.
-- In a full split, the body would be extracted from the environment.
