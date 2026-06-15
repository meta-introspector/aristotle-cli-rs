import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Decidable_isFalse
import Split.Eq
import Split.Not

-- Option.instDecidableEq.match_3 from environment
-- def Option.instDecidableEq.match_3 : forall {α : Type.{u_1}} (a : α) (b : α) (motive : (Decidable (Eq.{succ u_1} α a b)) -> Sort.{u_2}) (x._@.Init.Data.Option.Basic.3127222307._hygCtx._hyg.90 : Decidable (Eq.{succ u_1} α a b)), (forall (h : Eq.{succ u_1} α a b), motive (Decidable.isTrue (Eq.{succ u_1} α a b) h)) -> (forall (n : Not (Eq.{succ u_1} α a b)), motive (Decidable.isFalse (Eq.{succ u_1} α a b) n)) -> (motive x._@.Init.Data.Option.Basic.3127222307._hygCtx._hyg.90)
-- (definition body omitted)

-- Stub: this file represents the declaration `Option.instDecidableEq.match_3`.
-- In a full split, the body would be extracted from the environment.
