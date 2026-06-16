import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.instOfNatNat
import Split.Prod_fst
import Split.TypedDMZ_DMZPolicy_mk
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.DecidablePred
import Split.Nat
import Split.SizeOf_sizeOf
import Split.TypedDMZ_Capability
import Split.instAddNat
import Split.Eq_refl
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.Prod_snd
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.DMZPolicy.mk.sizeOf_spec from environment
-- theorem TypedDMZ.DMZPolicy.mk.sizeOf_spec : forall (rules : List.{0} TypedDMZ.DMZRule) (allows : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop) (decidable : DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))), Eq.{1} Nat (SizeOf.sizeOf.{1} TypedDMZ.DMZPolicy TypedDMZ.DMZPolicy._sizeOf_inst (TypedDMZ.DMZPolicy.mk rules allows decidable)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} TypedDMZ.DMZRule) (List._sizeOf_inst.{0} TypedDMZ.DMZRule TypedDMZ.DMZRule._sizeOf_inst) rules))

-- Stub: this file represents the declaration `TypedDMZ.DMZPolicy.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
