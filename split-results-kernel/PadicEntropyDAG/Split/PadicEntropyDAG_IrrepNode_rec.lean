import Split.PadicEntropyDAG_Metrics
import Split.String
import Split.Float
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.PadicEntropyDAG_IrrepNode_mk
import Split.Nat
import Split.Option

-- PadicEntropyDAG.IrrepNode.rec from environment
-- recursor PadicEntropyDAG.IrrepNode.rec : forall {motive : PadicEntropyDAG.IrrepNode -> Sort.{u}}, (forall (irrepIds : Array.{0} Nat) (notes : Option.{0} String) (exponents : Array.{0} Nat) (componentLog10Scales : Array.{0} Float) (metrics : PadicEntropyDAG.Metrics), motive (PadicEntropyDAG.IrrepNode.mk irrepIds notes exponents componentLog10Scales metrics)) -> (forall (t : PadicEntropyDAG.IrrepNode), motive t)

-- Stub: this file represents the declaration `PadicEntropyDAG.IrrepNode.rec`.
-- In a full split, the body would be extracted from the environment.
