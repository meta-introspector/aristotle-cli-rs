import Split.HEq_refl
import Split.Option_casesOn
import Split.Option_noConfusionType
import Split.eq_of_heq
import Split.Eq_ndrec
import Split.HEq
import Split.Eq
import Split.Option

-- Option.noConfusion from environment
-- def Option.noConfusion : forall {P : Sort.{u_1}} {α : Type.{u}} {t : Option.{u} α} {α' : Type.{u}} {t' : Option.{u} α'}, (Eq.{succ (succ u)} Type.{u} α α') -> (HEq.{succ u} (Option.{u} α) t (Option.{u} α') t') -> (Option.noConfusionType.{u_1, u} P α t α' t')
-- (definition body omitted)

-- Stub: this file represents the declaration `Option.noConfusion`.
-- In a full split, the body would be extracted from the environment.
