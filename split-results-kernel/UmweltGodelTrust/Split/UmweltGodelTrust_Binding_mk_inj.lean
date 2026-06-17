import Split.UmweltGodelTrust_Binding_mk
import Split.UmweltGodelTrust_Binding_mk_noConfusion
import Split.UmweltGodelTrust_Grade
import Split.UmweltGodelTrust_Binding
import Split.UmweltGodelTrust_BindingType
import Split.And
import Split.And_intro
import Split.Eq

-- UmweltGodelTrust.Binding.mk.inj from environment
-- theorem UmweltGodelTrust.Binding.mk.inj : forall {btype : UmweltGodelTrust.BindingType} {grade : UmweltGodelTrust.Grade} {btype_1 : UmweltGodelTrust.BindingType} {grade_1 : UmweltGodelTrust.Grade}, (Eq.{1} UmweltGodelTrust.Binding (UmweltGodelTrust.Binding.mk btype grade) (UmweltGodelTrust.Binding.mk btype_1 grade_1)) -> (And (Eq.{1} UmweltGodelTrust.BindingType btype btype_1) (Eq.{1} UmweltGodelTrust.Grade grade grade_1))

-- Stub: this file represents the declaration `UmweltGodelTrust.Binding.mk.inj`.
-- In a full split, the body would be extracted from the environment.
