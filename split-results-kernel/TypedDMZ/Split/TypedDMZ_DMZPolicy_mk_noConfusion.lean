import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.id
import Split.Prod_fst
import Split.TypedDMZ_DMZPolicy_mk
import Split.TypedDMZ_DMZPolicy_noConfusion
import Split.List
import Split.DecidablePred
import Split.TypedDMZ_Capability
import Split.HEq
import Split.Prod
import Split.Eq
import Split.Prod_snd
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.DMZPolicy.mk.noConfusion from environment
-- def TypedDMZ.DMZPolicy.mk.noConfusion : forall {P : Sort.{u}} {rules : List.{0} TypedDMZ.DMZRule} {allows : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop} {decidable : DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))} {rules' : List.{0} TypedDMZ.DMZRule} {allows' : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop} {decidable' : DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows' (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))}, (Eq.{1} TypedDMZ.DMZPolicy (TypedDMZ.DMZPolicy.mk rules allows decidable) (TypedDMZ.DMZPolicy.mk rules' allows' decidable')) -> ((Eq.{1} (List.{0} TypedDMZ.DMZRule) rules rules') -> (Eq.{1} (KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop) allows allows') -> (HEq.{1} (DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))) decidable (DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows' (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))) decidable') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.DMZPolicy.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
