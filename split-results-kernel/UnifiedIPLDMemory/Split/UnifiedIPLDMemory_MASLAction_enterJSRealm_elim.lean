import Split.PULift_up
import Split.UnifiedIPLDMemory_MASLAction_ctorElim
import Split.UnifiedIPLDMemory_MASLAction
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_MASLAction_ctorIdx
import Split.UnifiedIPLDMemory_MASLAction_enterJSRealm
import Split.Nat
import Split.Eq_symm
import Split.Eq

-- UnifiedIPLDMemory.MASLAction.enterJSRealm.elim from environment
-- def UnifiedIPLDMemory.MASLAction.enterJSRealm.elim : forall {motive : UnifiedIPLDMemory.MASLAction -> Sort.{u}} (t : UnifiedIPLDMemory.MASLAction), (Eq.{1} Nat (UnifiedIPLDMemory.MASLAction.ctorIdx t) 1) -> (forall (moduleCID : UnifiedIPLDMemory.IPLDCID), motive (UnifiedIPLDMemory.MASLAction.enterJSRealm moduleCID)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MASLAction.enterJSRealm.elim`.
-- In a full split, the body would be extracted from the environment.
