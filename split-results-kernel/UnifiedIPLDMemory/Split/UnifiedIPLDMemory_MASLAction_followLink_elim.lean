import Split.PULift_up
import Split.UnifiedIPLDMemory_MASLAction_followLink
import Split.UnifiedIPLDMemory_MASLAction_ctorElim
import Split.UnifiedIPLDMemory_MASLAction
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_MASLAction_ctorIdx
import Split.Nat
import Split.Eq_symm
import Split.Eq

-- UnifiedIPLDMemory.MASLAction.followLink.elim from environment
-- def UnifiedIPLDMemory.MASLAction.followLink.elim : forall {motive : UnifiedIPLDMemory.MASLAction -> Sort.{u}} (t : UnifiedIPLDMemory.MASLAction), (Eq.{1} Nat (UnifiedIPLDMemory.MASLAction.ctorIdx t) 0) -> (forall (targetCID : UnifiedIPLDMemory.IPLDCID), motive (UnifiedIPLDMemory.MASLAction.followLink targetCID)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MASLAction.followLink.elim`.
-- In a full split, the body would be extracted from the environment.
