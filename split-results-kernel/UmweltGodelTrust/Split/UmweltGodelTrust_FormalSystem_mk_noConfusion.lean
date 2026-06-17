import Split.UmweltGodelTrust_FormalSystem
import Split.String
import Split.id
import Split.UmweltGodelTrust_FormalSystem_noConfusion
import Split.UmweltGodelTrust_FormalSystem_mk
import Split.Bool
import Split.Eq

-- UmweltGodelTrust.FormalSystem.mk.noConfusion from environment
-- def UmweltGodelTrust.FormalSystem.mk.noConfusion : forall {P : Sort.{u}} {name : String} {expresses_arithmetic : Bool} {consistent : Bool} {name' : String} {expresses_arithmetic' : Bool} {consistent' : Bool}, (Eq.{1} UmweltGodelTrust.FormalSystem (UmweltGodelTrust.FormalSystem.mk name expresses_arithmetic consistent) (UmweltGodelTrust.FormalSystem.mk name' expresses_arithmetic' consistent')) -> ((Eq.{1} String name name') -> (Eq.{1} Bool expresses_arithmetic expresses_arithmetic') -> (Eq.{1} Bool consistent consistent') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UmweltGodelTrust.FormalSystem.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
