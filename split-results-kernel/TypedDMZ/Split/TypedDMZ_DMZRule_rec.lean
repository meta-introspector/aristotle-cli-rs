import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.TypedDMZ_DMZRule_mk
import Split.TypedDMZ_Capability

-- TypedDMZ.DMZRule.rec from environment
-- recursor TypedDMZ.DMZRule.rec : forall {motive : TypedDMZ.DMZRule -> Sort.{u}}, (forall (dataset : KernelGovernance.Dataset) (fieldName : String) (capability : TypedDMZ.Capability), motive (TypedDMZ.DMZRule.mk dataset fieldName capability)) -> (forall (t : TypedDMZ.DMZRule), motive t)

-- Stub: this file represents the declaration `TypedDMZ.DMZRule.rec`.
-- In a full split, the body would be extracted from the environment.
