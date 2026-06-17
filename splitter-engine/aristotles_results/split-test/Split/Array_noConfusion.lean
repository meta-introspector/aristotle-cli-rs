import Split.HEq_refl
import Split.Array_noConfusionType
import Split.Array_casesOn
import Split.Array
import Split.List
import Split.eq_of_heq
import Split.Eq_ndrec
import Split.HEq
import Split.Eq

-- Array.noConfusion from environment
-- def Array.noConfusion : forall {P : Sort.{u_1}} {α : Type.{u}} {t : Array.{u} α} {α' : Type.{u}} {t' : Array.{u} α'}, (Eq.{succ (succ u)} Type.{u} α α') -> (HEq.{succ u} (Array.{u} α) t (Array.{u} α') t') -> (Array.noConfusionType.{u_1, u} P α t α' t')
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.noConfusion`.
-- In a full split, the body would be extracted from the environment.
