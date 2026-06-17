import Split.ContentAddressing_HashFunction_mk_inj
import Split.Eq_propIntro
import Split.String
import Split.Lean_injEq_helper
import Split.And
import Split.ContentAddressing_HashFunction_mk
import Split.Nat
import Split.ContentAddressing_HashFunction
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq

-- ContentAddressing.HashFunction.mk.injEq from environment
-- theorem ContentAddressing.HashFunction.mk.injEq : forall (name : String) (apply : String -> Nat) (name_1 : String) (apply_1 : String -> Nat), Eq.{1} Prop (Eq.{1} ContentAddressing.HashFunction (ContentAddressing.HashFunction.mk name apply) (ContentAddressing.HashFunction.mk name_1 apply_1)) (And (Eq.{1} String name name_1) (Eq.{1} (String -> Nat) apply apply_1))

-- Stub: this file represents the declaration `ContentAddressing.HashFunction.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
