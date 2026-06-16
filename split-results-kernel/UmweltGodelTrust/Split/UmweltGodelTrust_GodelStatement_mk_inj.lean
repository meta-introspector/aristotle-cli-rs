import Split.UmweltGodelTrust_FormalSystem
import Split.And
import Split.UmweltGodelTrust_GodelStatement
import Split.And_intro
import Split.Bool
import Split.UmweltGodelTrust_GodelStatement_mk_noConfusion
import Split.Eq
import Split.UmweltGodelTrust_GodelStatement_mk

-- UmweltGodelTrust.GodelStatement.mk.inj from environment
-- theorem UmweltGodelTrust.GodelStatement.mk.inj : forall {S : UmweltGodelTrust.FormalSystem} {well_formed : Bool} {self_referential : Bool} {well_formed_1 : Bool} {self_referential_1 : Bool}, (Eq.{1} (UmweltGodelTrust.GodelStatement S) (UmweltGodelTrust.GodelStatement.mk S well_formed self_referential) (UmweltGodelTrust.GodelStatement.mk S well_formed_1 self_referential_1)) -> (And (Eq.{1} Bool well_formed well_formed_1) (Eq.{1} Bool self_referential self_referential_1))

-- Stub: this file represents the declaration `UmweltGodelTrust.GodelStatement.mk.inj`.
-- In a full split, the body would be extracted from the environment.
