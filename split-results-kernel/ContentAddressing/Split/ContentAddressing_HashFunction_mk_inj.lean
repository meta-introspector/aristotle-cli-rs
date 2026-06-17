import Split.String
import Split.And
import Split.ContentAddressing_HashFunction_mk
import Split.Nat
import Split.ContentAddressing_HashFunction
import Split.And_intro
import Split.Eq
import Split.ContentAddressing_HashFunction_mk_noConfusion

-- ContentAddressing.HashFunction.mk.inj from environment
-- theorem ContentAddressing.HashFunction.mk.inj : forall {name : String} {apply : String -> Nat} {name_1 : String} {apply_1 : String -> Nat}, (Eq.{1} ContentAddressing.HashFunction (ContentAddressing.HashFunction.mk name apply) (ContentAddressing.HashFunction.mk name_1 apply_1)) -> (And (Eq.{1} String name name_1) (Eq.{1} (String -> Nat) apply apply_1))

-- Stub: this file represents the declaration `ContentAddressing.HashFunction.mk.inj`.
-- In a full split, the body would be extracted from the environment.
