import Split.UmweltGodelTrust_Binding_mk
import Split.UmweltGodelTrust_Binding_noConfusion
import Split.id
import Split.UmweltGodelTrust_Grade
import Split.UmweltGodelTrust_Binding
import Split.UmweltGodelTrust_BindingType
import Split.Eq

-- UmweltGodelTrust.Binding.mk.noConfusion from environment
-- def UmweltGodelTrust.Binding.mk.noConfusion : forall {P : Sort.{u}} {btype : UmweltGodelTrust.BindingType} {grade : UmweltGodelTrust.Grade} {btype' : UmweltGodelTrust.BindingType} {grade' : UmweltGodelTrust.Grade}, (Eq.{1} UmweltGodelTrust.Binding (UmweltGodelTrust.Binding.mk btype grade) (UmweltGodelTrust.Binding.mk btype' grade')) -> ((Eq.{1} UmweltGodelTrust.BindingType btype btype') -> (Eq.{1} UmweltGodelTrust.Grade grade grade') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UmweltGodelTrust.Binding.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
