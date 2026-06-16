import Split.id
import Split.UmweltGodelTrust_TrustArchitecture_noConfusion
import Split.UmweltGodelTrust_TrustArchitecture_mk
import Split.Bool
import Split.Eq
import Split.UmweltGodelTrust_TrustArchitecture

-- UmweltGodelTrust.TrustArchitecture.mk.noConfusion from environment
-- def UmweltGodelTrust.TrustArchitecture.mk.noConfusion : forall {P : Sort.{u}} {minimal_kernel : Bool} {external_audit : Bool} {arch_separation : Bool} {minimal_kernel' : Bool} {external_audit' : Bool} {arch_separation' : Bool}, (Eq.{1} UmweltGodelTrust.TrustArchitecture (UmweltGodelTrust.TrustArchitecture.mk minimal_kernel external_audit arch_separation) (UmweltGodelTrust.TrustArchitecture.mk minimal_kernel' external_audit' arch_separation')) -> ((Eq.{1} Bool minimal_kernel minimal_kernel') -> (Eq.{1} Bool external_audit external_audit') -> (Eq.{1} Bool arch_separation arch_separation') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UmweltGodelTrust.TrustArchitecture.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
