import Split.Eq_propIntro
import Split.PadicEntropyDAG_DagLayers_mk_inj
import Split.Lean_injEq_helper
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.And
import Split.PadicEntropyDAG_RootConfig
import Split.Eq_ndrec
import Split.Eq_refl
import Split.PadicEntropyDAG_DagLayers_mk
import Split.Eq
import Split.PadicEntropyDAG_DagLayers

-- PadicEntropyDAG.DagLayers.mk.injEq from environment
-- theorem PadicEntropyDAG.DagLayers.mk.injEq : forall (rootConfig : PadicEntropyDAG.RootConfig) (nodes : Array.{0} PadicEntropyDAG.IrrepNode) (rootConfig_1 : PadicEntropyDAG.RootConfig) (nodes_1 : Array.{0} PadicEntropyDAG.IrrepNode), Eq.{1} Prop (Eq.{1} PadicEntropyDAG.DagLayers (PadicEntropyDAG.DagLayers.mk rootConfig nodes) (PadicEntropyDAG.DagLayers.mk rootConfig_1 nodes_1)) (And (Eq.{1} PadicEntropyDAG.RootConfig rootConfig rootConfig_1) (Eq.{1} (Array.{0} PadicEntropyDAG.IrrepNode) nodes nodes_1))

-- Stub: this file represents the declaration `PadicEntropyDAG.DagLayers.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
