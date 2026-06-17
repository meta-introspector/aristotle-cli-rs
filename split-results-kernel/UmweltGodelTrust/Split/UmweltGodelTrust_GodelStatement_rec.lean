import Split.UmweltGodelTrust_FormalSystem
import Split.UmweltGodelTrust_GodelStatement
import Split.Bool
import Split.UmweltGodelTrust_GodelStatement_mk

-- UmweltGodelTrust.GodelStatement.rec from environment
-- recursor UmweltGodelTrust.GodelStatement.rec : forall {S : UmweltGodelTrust.FormalSystem} {motive : (UmweltGodelTrust.GodelStatement S) -> Sort.{u}}, (forall (well_formed : Bool) (self_referential : Bool), motive (UmweltGodelTrust.GodelStatement.mk S well_formed self_referential)) -> (forall (t : UmweltGodelTrust.GodelStatement S), motive t)

-- Stub: this file represents the declaration `UmweltGodelTrust.GodelStatement.rec`.
-- In a full split, the body would be extracted from the environment.
