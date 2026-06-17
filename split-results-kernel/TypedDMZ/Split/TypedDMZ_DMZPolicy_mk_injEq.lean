import Split.TypedDMZ_DMZPolicy_mk_inj
import Split.Eq_propIntro
import Split.String
import Split.TypedDMZ_DMZRule
import Split.Lean_injEq_helper
import Split.KernelGovernance_Dataset
import Split.HEq_homo_ndrec
import Split.Prod_fst
import Split.TypedDMZ_DMZPolicy_mk
import Split.List
import Split.And
import Split.DecidablePred
import Split.TypedDMZ_Capability
import Split.Eq_ndrec
import Split.Eq_refl
import Split.HEq
import Split.Prod
import Split.Eq
import Split.Prod_snd
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.DMZPolicy.mk.injEq from environment
-- theorem TypedDMZ.DMZPolicy.mk.injEq : forall (rules : List.{0} TypedDMZ.DMZRule) (allows : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop) (decidable : DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))) (rules_1 : List.{0} TypedDMZ.DMZRule) (allows_1 : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop) (decidable_1 : DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows_1 (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))), Eq.{1} Prop (Eq.{1} TypedDMZ.DMZPolicy (TypedDMZ.DMZPolicy.mk rules allows decidable) (TypedDMZ.DMZPolicy.mk rules_1 allows_1 decidable_1)) (And (Eq.{1} (List.{0} TypedDMZ.DMZRule) rules rules_1) (And (Eq.{1} (KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop) allows allows_1) (HEq.{1} (DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))) decidable (DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows_1 (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))) decidable_1)))

-- Stub: this file represents the declaration `TypedDMZ.DMZPolicy.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
