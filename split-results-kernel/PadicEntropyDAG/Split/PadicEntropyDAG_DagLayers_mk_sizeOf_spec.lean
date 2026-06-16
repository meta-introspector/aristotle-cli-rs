import Split.instOfNatNat
import Split.Array
import Split.PadicEntropyDAG_IrrepNode
import Split.instHAdd
import Split.HAdd_hAdd
import Split.PadicEntropyDAG_RootConfig
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.PadicEntropyDAG_DagLayers_mk
import Split.Eq
import Split.PadicEntropyDAG_DagLayers

-- PadicEntropyDAG.DagLayers.mk.sizeOf_spec from environment
-- theorem PadicEntropyDAG.DagLayers.mk.sizeOf_spec : forall (rootConfig : PadicEntropyDAG.RootConfig) (nodes : Array.{0} PadicEntropyDAG.IrrepNode), Eq.{1} Nat (SizeOf.sizeOf.{1} PadicEntropyDAG.DagLayers PadicEntropyDAG.DagLayers._sizeOf_inst (PadicEntropyDAG.DagLayers.mk rootConfig nodes)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} PadicEntropyDAG.RootConfig PadicEntropyDAG.RootConfig._sizeOf_inst rootConfig)) (SizeOf.sizeOf.{1} (Array.{0} PadicEntropyDAG.IrrepNode) (Array._sizeOf_inst.{0} PadicEntropyDAG.IrrepNode PadicEntropyDAG.IrrepNode._sizeOf_inst) nodes))

-- Stub: this file represents the declaration `PadicEntropyDAG.DagLayers.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
