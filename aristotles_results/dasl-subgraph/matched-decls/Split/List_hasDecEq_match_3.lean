import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Decidable_isFalse
import Split.Eq
import Split.Not

-- List.hasDecEq.match_3 from environment
-- def List.hasDecEq.match_3 : forall {α : Type.{u_1}} (a : α) (b : α) (motive : (Decidable (Eq.{succ u_1} α a b)) -> Sort.{u_2}) (x._@.Init.Prelude.1398671996._hygCtx._hyg.131 : Decidable (Eq.{succ u_1} α a b)), (forall (hab : Eq.{succ u_1} α a b), motive (Decidable.isTrue (Eq.{succ u_1} α a b) hab)) -> (forall (nab : Not (Eq.{succ u_1} α a b)), motive (Decidable.isFalse (Eq.{succ u_1} α a b) nab)) -> (motive x._@.Init.Prelude.1398671996._hygCtx._hyg.131)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.hasDecEq.match_3`.
-- In a full split, the body would be extracted from the environment.
