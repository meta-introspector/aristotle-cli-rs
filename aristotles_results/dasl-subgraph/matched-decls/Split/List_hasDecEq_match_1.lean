import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.List
import Split.Decidable_isFalse
import Split.Eq
import Split.Not

-- List.hasDecEq.match_1 from environment
-- def List.hasDecEq.match_1 : forall {α : Type.{u_1}} (as : List.{u_1} α) (bs : List.{u_1} α) (motive : (Decidable (Eq.{succ u_1} (List.{u_1} α) as bs)) -> Sort.{u_2}) (x._@.Init.Prelude.1398671996._hygCtx._hyg.146 : Decidable (Eq.{succ u_1} (List.{u_1} α) as bs)), (forall (habs : Eq.{succ u_1} (List.{u_1} α) as bs), motive (Decidable.isTrue (Eq.{succ u_1} (List.{u_1} α) as bs) habs)) -> (forall (nabs : Not (Eq.{succ u_1} (List.{u_1} α) as bs)), motive (Decidable.isFalse (Eq.{succ u_1} (List.{u_1} α) as bs) nabs)) -> (motive x._@.Init.Prelude.1398671996._hygCtx._hyg.146)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.hasDecEq.match_1`.
-- In a full split, the body would be extracted from the environment.
