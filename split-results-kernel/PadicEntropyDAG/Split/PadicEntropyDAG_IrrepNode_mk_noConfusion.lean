import Split.PadicEntropyDAG_Metrics
import Split.String
import Split.Float
import Split.id
import Split.PadicEntropyDAG_IrrepNode_noConfusion
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.PadicEntropyDAG_IrrepNode_mk
import Split.Nat
import Split.Eq
import Split.Option

-- PadicEntropyDAG.IrrepNode.mk.noConfusion from environment
-- def PadicEntropyDAG.IrrepNode.mk.noConfusion : forall {P : Sort.{u}} {irrepIds : Array.{0} Nat} {notes : Option.{0} String} {exponents : Array.{0} Nat} {componentLog10Scales : Array.{0} Float} {metrics : PadicEntropyDAG.Metrics} {irrepIds' : Array.{0} Nat} {notes' : Option.{0} String} {exponents' : Array.{0} Nat} {componentLog10Scales' : Array.{0} Float} {metrics' : PadicEntropyDAG.Metrics}, (Eq.{1} PadicEntropyDAG.IrrepNode (PadicEntropyDAG.IrrepNode.mk irrepIds notes exponents componentLog10Scales metrics) (PadicEntropyDAG.IrrepNode.mk irrepIds' notes' exponents' componentLog10Scales' metrics')) -> ((Eq.{1} (Array.{0} Nat) irrepIds irrepIds') -> (Eq.{1} (Option.{0} String) notes notes') -> (Eq.{1} (Array.{0} Nat) exponents exponents') -> (Eq.{1} (Array.{0} Float) componentLog10Scales componentLog10Scales') -> (Eq.{1} PadicEntropyDAG.Metrics metrics metrics') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `PadicEntropyDAG.IrrepNode.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
