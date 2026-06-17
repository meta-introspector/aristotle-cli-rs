import Split.UnifiedIPLDMemory_AgentStep_mk_noConfusion
import Split.UnifiedIPLDMemory_MASLAction
import Split.UnifiedIPLDMemory_WebTile
import Split.And
import Split.And_intro
import Split.UnifiedIPLDMemory_AgentStep_mk
import Split.UnifiedIPLDMemory_AgentStep
import Split.Eq

-- UnifiedIPLDMemory.AgentStep.mk.inj from environment
-- theorem UnifiedIPLDMemory.AgentStep.mk.inj : forall {currentTile : UnifiedIPLDMemory.WebTile} {action : UnifiedIPLDMemory.MASLAction} {resultTile : UnifiedIPLDMemory.WebTile} {currentTile_1 : UnifiedIPLDMemory.WebTile} {action_1 : UnifiedIPLDMemory.MASLAction} {resultTile_1 : UnifiedIPLDMemory.WebTile}, (Eq.{1} UnifiedIPLDMemory.AgentStep (UnifiedIPLDMemory.AgentStep.mk currentTile action resultTile) (UnifiedIPLDMemory.AgentStep.mk currentTile_1 action_1 resultTile_1)) -> (And (Eq.{1} UnifiedIPLDMemory.WebTile currentTile currentTile_1) (And (Eq.{1} UnifiedIPLDMemory.MASLAction action action_1) (Eq.{1} UnifiedIPLDMemory.WebTile resultTile resultTile_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.AgentStep.mk.inj`.
-- In a full split, the body would be extracted from the environment.
