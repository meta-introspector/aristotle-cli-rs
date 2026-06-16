import Split.String
import Split.KernelGovernance_Dataset
import Split.Prod_fst
import Split.DecidablePred
import Split.TypedDMZ_Capability
import Split.Prod
import Split.Prod_snd
import Split.TypedDMZ_DMZPolicy_allows
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.DMZPolicy.decidable from environment
-- def TypedDMZ.DMZPolicy.decidable : forall (self : TypedDMZ.DMZPolicy), DecidablePred.{1} (Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) (fun (t : Prod.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability)) => TypedDMZ.DMZPolicy.allows self (Prod.fst.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t) (Prod.fst.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)) (Prod.snd.{0, 0} String TypedDMZ.Capability (Prod.snd.{0, 0} KernelGovernance.Dataset (Prod.{0, 0} String TypedDMZ.Capability) t)))
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.DMZPolicy.decidable`.
-- In a full split, the body would be extracted from the environment.
