import Split.UmweltGodelTrust_FormalSystem_mk_noConfusion
import Split.UmweltGodelTrust_FormalSystem
import Split.String
import Split.And
import Split.UmweltGodelTrust_FormalSystem_mk
import Split.And_intro
import Split.Bool
import Split.Eq

-- UmweltGodelTrust.FormalSystem.mk.inj from environment
-- theorem UmweltGodelTrust.FormalSystem.mk.inj : forall {name : String} {expresses_arithmetic : Bool} {consistent : Bool} {name_1 : String} {expresses_arithmetic_1 : Bool} {consistent_1 : Bool}, (Eq.{1} UmweltGodelTrust.FormalSystem (UmweltGodelTrust.FormalSystem.mk name expresses_arithmetic consistent) (UmweltGodelTrust.FormalSystem.mk name_1 expresses_arithmetic_1 consistent_1)) -> (And (Eq.{1} String name name_1) (And (Eq.{1} Bool expresses_arithmetic expresses_arithmetic_1) (Eq.{1} Bool consistent consistent_1)))

-- Stub: this file represents the declaration `UmweltGodelTrust.FormalSystem.mk.inj`.
-- In a full split, the body would be extracted from the environment.
