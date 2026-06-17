import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.Prod_fst
import Split.List
import Split.DecidablePred
import Split.TypedDMZ_Capability
import Split.Prod
import Split.Prod_snd
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.DMZPolicy.mk from environment
-- constructor TypedDMZ.DMZPolicy.mk : (List.{0} TypedDMZ.DMZRule) -> (forall (allows : KernelGovernance.Dataset -> String -> TypedDMZ.Capability -> Prop), (DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => allows (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))) -> TypedDMZ.DMZPolicy)

-- Stub: this file represents the declaration `TypedDMZ.DMZPolicy.mk`.
-- In a full split, the body would be extracted from the environment.
