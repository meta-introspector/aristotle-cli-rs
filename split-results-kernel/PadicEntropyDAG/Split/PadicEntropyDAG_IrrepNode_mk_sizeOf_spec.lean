import Split.PadicEntropyDAG_Metrics
import Split.String
import Split.Float
import Split.instOfNatNat
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.instHAdd
import Split.PadicEntropyDAG_IrrepNode_mk
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Option

-- PadicEntropyDAG.IrrepNode.mk.sizeOf_spec from environment
-- theorem PadicEntropyDAG.IrrepNode.mk.sizeOf_spec : forall (irrepIds : Array.{0} Nat) (notes : Option.{0} String) (exponents : Array.{0} Nat) (componentLog10Scales : Array.{0} Float) (metrics : PadicEntropyDAG.Metrics), Eq.{1} Nat (SizeOf.sizeOf.{1} PadicEntropyDAG.IrrepNode PadicEntropyDAG.IrrepNode._sizeOf_inst (PadicEntropyDAG.IrrepNode.mk irrepIds notes exponents componentLog10Scales metrics)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (Array.{0} Nat) (Array._sizeOf_inst.{0} Nat instSizeOfNat) irrepIds)) (SizeOf.sizeOf.{1} (Option.{0} String) (Option._sizeOf_inst.{0} String String._sizeOf_inst) notes)) (SizeOf.sizeOf.{1} (Array.{0} Nat) (Array._sizeOf_inst.{0} Nat instSizeOfNat) exponents)) (SizeOf.sizeOf.{1} (Array.{0} Float) (Array._sizeOf_inst.{0} Float Float._sizeOf_inst) componentLog10Scales)) (SizeOf.sizeOf.{1} PadicEntropyDAG.Metrics PadicEntropyDAG.Metrics._sizeOf_inst metrics))

-- Stub: this file represents the declaration `PadicEntropyDAG.IrrepNode.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
