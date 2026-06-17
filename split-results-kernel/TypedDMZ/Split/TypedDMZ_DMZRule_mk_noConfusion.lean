import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.TypedDMZ_DMZRule_mk
import Split.id
import Split.TypedDMZ_Capability
import Split.Eq
import Split.TypedDMZ_DMZRule_noConfusion

-- TypedDMZ.DMZRule.mk.noConfusion from environment
-- def TypedDMZ.DMZRule.mk.noConfusion : forall {P : Sort.{u}} {dataset : KernelGovernance.Dataset} {fieldName : String} {capability : TypedDMZ.Capability} {dataset' : KernelGovernance.Dataset} {fieldName' : String} {capability' : TypedDMZ.Capability}, (Eq.{1} TypedDMZ.DMZRule (TypedDMZ.DMZRule.mk dataset fieldName capability) (TypedDMZ.DMZRule.mk dataset' fieldName' capability')) -> ((Eq.{1} KernelGovernance.Dataset dataset dataset') -> (Eq.{1} String fieldName fieldName') -> (Eq.{1} TypedDMZ.Capability capability capability') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.DMZRule.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
