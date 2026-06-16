import Split.PadicEntropyDAG_IrrepNode_mk_noConfusion
import Split.PadicEntropyDAG_Metrics
import Split.String
import Split.Float
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.And
import Split.PadicEntropyDAG_IrrepNode_mk
import Split.Nat
import Split.And_intro
import Split.Eq
import Split.Option

-- PadicEntropyDAG.IrrepNode.mk.inj from environment
-- theorem PadicEntropyDAG.IrrepNode.mk.inj : forall {irrepIds : Array.{0} Nat} {notes : Option.{0} String} {exponents : Array.{0} Nat} {componentLog10Scales : Array.{0} Float} {metrics : PadicEntropyDAG.Metrics} {irrepIds_1 : Array.{0} Nat} {notes_1 : Option.{0} String} {exponents_1 : Array.{0} Nat} {componentLog10Scales_1 : Array.{0} Float} {metrics_1 : PadicEntropyDAG.Metrics}, (Eq.{1} PadicEntropyDAG.IrrepNode (PadicEntropyDAG.IrrepNode.mk irrepIds notes exponents componentLog10Scales metrics) (PadicEntropyDAG.IrrepNode.mk irrepIds_1 notes_1 exponents_1 componentLog10Scales_1 metrics_1)) -> (And (Eq.{1} (Array.{0} Nat) irrepIds irrepIds_1) (And (Eq.{1} (Option.{0} String) notes notes_1) (And (Eq.{1} (Array.{0} Nat) exponents exponents_1) (And (Eq.{1} (Array.{0} Float) componentLog10Scales componentLog10Scales_1) (Eq.{1} PadicEntropyDAG.Metrics metrics metrics_1)))))

-- Stub: this file represents the declaration `PadicEntropyDAG.IrrepNode.mk.inj`.
-- In a full split, the body would be extracted from the environment.
