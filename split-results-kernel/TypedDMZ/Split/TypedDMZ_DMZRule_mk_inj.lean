import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.TypedDMZ_DMZRule_mk_noConfusion
import Split.TypedDMZ_DMZRule_mk
import Split.And
import Split.And_intro
import Split.TypedDMZ_Capability
import Split.Eq

-- TypedDMZ.DMZRule.mk.inj from environment
-- theorem TypedDMZ.DMZRule.mk.inj : forall {dataset : KernelGovernance.Dataset} {fieldName : String} {capability : TypedDMZ.Capability} {dataset_1 : KernelGovernance.Dataset} {fieldName_1 : String} {capability_1 : TypedDMZ.Capability}, (Eq.{1} TypedDMZ.DMZRule (TypedDMZ.DMZRule.mk dataset fieldName capability) (TypedDMZ.DMZRule.mk dataset_1 fieldName_1 capability_1)) -> (And (Eq.{1} KernelGovernance.Dataset dataset dataset_1) (And (Eq.{1} String fieldName fieldName_1) (Eq.{1} TypedDMZ.Capability capability capability_1)))

-- Stub: this file represents the declaration `TypedDMZ.DMZRule.mk.inj`.
-- In a full split, the body would be extracted from the environment.
