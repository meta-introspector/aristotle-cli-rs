import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.Prod_fst
import Split.TypedDMZ_DMZPolicy_mk
import Split.List
import Split.DecidablePred
import Split.TypedDMZ_Capability
import Split.Prod
import Split.Prod_snd
import Split.TypedDMZ_DMZPolicy
import Split.TypedDMZ_DMZPolicy_rec

-- TypedDMZ.DMZPolicy.casesOn from environment
-- def TypedDMZ.DMZPolicy.casesOn : forall {motive : TypedDMZ.DMZPolicy -> Sort.{u}} (t : TypedDMZ.DMZPolicy), (forall (rules : List.{0} TypedDMZ.DMZRule) (allows : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop) (decidable : DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))), motive (TypedDMZ.DMZPolicy.mk rules allows decidable)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.DMZPolicy.casesOn`.
-- In a full split, the body would be extracted from the environment.
