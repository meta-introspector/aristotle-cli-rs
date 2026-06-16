import Split.String
import Split.id
import Split.ContentAddressing_HashFunction_mk
import Split.Nat
import Split.ContentAddressing_HashFunction
import Split.Eq
import Split.ContentAddressing_HashFunction_noConfusion

-- ContentAddressing.HashFunction.mk.noConfusion from environment
-- def ContentAddressing.HashFunction.mk.noConfusion : forall {P : Sort.{u}} {name : String} {apply : String -> Nat} {name' : String} {apply' : String -> Nat}, (Eq.{1} ContentAddressing.HashFunction (ContentAddressing.HashFunction.mk name apply) (ContentAddressing.HashFunction.mk name' apply')) -> ((Eq.{1} String name name') -> (Eq.{1} (String -> Nat) apply apply') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.HashFunction.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
