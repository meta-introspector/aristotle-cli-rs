import Split.Eq_propIntro
import Split.UmweltGodelTrust_FormalSystem
import Split.Lean_injEq_helper
import Split.UmweltGodelTrust_GodelStatement_mk_inj
import Split.And
import Split.UmweltGodelTrust_GodelStatement
import Split.Bool
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq
import Split.UmweltGodelTrust_GodelStatement_mk

-- UmweltGodelTrust.GodelStatement.mk.injEq from environment
-- theorem UmweltGodelTrust.GodelStatement.mk.injEq : forall {S : UmweltGodelTrust.FormalSystem} (well_formed : Bool) (self_referential : Bool) (well_formed_1 : Bool) (self_referential_1 : Bool), Eq.{1} Prop (Eq.{1} (UmweltGodelTrust.GodelStatement S) (UmweltGodelTrust.GodelStatement.mk S well_formed self_referential) (UmweltGodelTrust.GodelStatement.mk S well_formed_1 self_referential_1)) (And (Eq.{1} Bool well_formed well_formed_1) (Eq.{1} Bool self_referential self_referential_1))

-- Stub: this file represents the declaration `UmweltGodelTrust.GodelStatement.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
