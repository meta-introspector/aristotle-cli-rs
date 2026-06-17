import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.And
import Split.UmweltGodelTrust_TrustArchitecture_mk
import Split.Bool
import Split.Eq_ndrec
import Split.UmweltGodelTrust_TrustArchitecture_mk_inj
import Split.Eq_refl
import Split.Eq
import Split.UmweltGodelTrust_TrustArchitecture

-- UmweltGodelTrust.TrustArchitecture.mk.injEq from environment
-- theorem UmweltGodelTrust.TrustArchitecture.mk.injEq : forall (minimal_kernel : Bool) (external_audit : Bool) (arch_separation : Bool) (minimal_kernel_1 : Bool) (external_audit_1 : Bool) (arch_separation_1 : Bool), Eq.{1} Prop (Eq.{1} UmweltGodelTrust.TrustArchitecture (UmweltGodelTrust.TrustArchitecture.mk minimal_kernel external_audit arch_separation) (UmweltGodelTrust.TrustArchitecture.mk minimal_kernel_1 external_audit_1 arch_separation_1)) (And (Eq.{1} Bool minimal_kernel minimal_kernel_1) (And (Eq.{1} Bool external_audit external_audit_1) (Eq.{1} Bool arch_separation arch_separation_1)))

-- Stub: this file represents the declaration `UmweltGodelTrust.TrustArchitecture.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
