import Split.String
import Split.Float
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.PadicEntropyDAG_RootConfig
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.PadicEntropyDAG_RootConfig_mk

-- PadicEntropyDAG.RootConfig.mk.sizeOf_spec from environment
-- theorem PadicEntropyDAG.RootConfig.mk.sizeOf_spec : forall (id : String) (type : String) (bitsMax : Float) (tritsMax : Float), Eq.{1} Nat (SizeOf.sizeOf.{1} PadicEntropyDAG.RootConfig PadicEntropyDAG.RootConfig._sizeOf_inst (PadicEntropyDAG.RootConfig.mk id type bitsMax tritsMax)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst id)) (SizeOf.sizeOf.{1} String String._sizeOf_inst type)) (SizeOf.sizeOf.{1} Float Float._sizeOf_inst bitsMax)) (SizeOf.sizeOf.{1} Float Float._sizeOf_inst tritsMax))

-- Stub: this file represents the declaration `PadicEntropyDAG.RootConfig.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
