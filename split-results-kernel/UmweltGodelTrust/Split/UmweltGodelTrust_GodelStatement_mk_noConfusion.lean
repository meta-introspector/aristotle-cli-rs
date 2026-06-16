import Split.UmweltGodelTrust_FormalSystem
import Split.id
import Split.UmweltGodelTrust_GodelStatement_noConfusion
import Split.heq_of_eq
import Split.UmweltGodelTrust_GodelStatement
import Split.Bool
import Split.Eq_refl
import Split.Eq
import Split.UmweltGodelTrust_GodelStatement_mk

-- UmweltGodelTrust.GodelStatement.mk.noConfusion from environment
-- def UmweltGodelTrust.GodelStatement.mk.noConfusion : forall {S : UmweltGodelTrust.FormalSystem} {P : Sort.{u}} {well_formed : Bool} {self_referential : Bool} {well_formed' : Bool} {self_referential' : Bool}, (Eq.{1} (UmweltGodelTrust.GodelStatement S) (UmweltGodelTrust.GodelStatement.mk S well_formed self_referential) (UmweltGodelTrust.GodelStatement.mk S well_formed' self_referential')) -> ((Eq.{1} Bool well_formed well_formed') -> (Eq.{1} Bool self_referential self_referential') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UmweltGodelTrust.GodelStatement.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
