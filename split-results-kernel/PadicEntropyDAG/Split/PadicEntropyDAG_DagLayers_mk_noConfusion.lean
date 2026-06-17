import Split.id
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.PadicEntropyDAG_RootConfig
import Split.PadicEntropyDAG_DagLayers_noConfusion
import Split.PadicEntropyDAG_DagLayers_mk
import Split.Eq
import Split.PadicEntropyDAG_DagLayers

-- PadicEntropyDAG.DagLayers.mk.noConfusion from environment
-- def PadicEntropyDAG.DagLayers.mk.noConfusion : forall {P : Sort.{u}} {rootConfig : PadicEntropyDAG.RootConfig} {nodes : Array.{0} PadicEntropyDAG.IrrepNode} {rootConfig' : PadicEntropyDAG.RootConfig} {nodes' : Array.{0} PadicEntropyDAG.IrrepNode}, (Eq.{1} PadicEntropyDAG.DagLayers (PadicEntropyDAG.DagLayers.mk rootConfig nodes) (PadicEntropyDAG.DagLayers.mk rootConfig' nodes')) -> ((Eq.{1} PadicEntropyDAG.RootConfig rootConfig rootConfig') -> (Eq.{1} (Array.{0} PadicEntropyDAG.IrrepNode) nodes nodes') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `PadicEntropyDAG.DagLayers.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
