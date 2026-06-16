import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Decidable_isFalse
import Split.Eq
import Split.Not

-- instDecidableEqProd.match_1 from environment
-- def instDecidableEqProd.match_1 : forall {β : Type.{u_1}} (b : β) (b' : β) (motive : (Decidable (Eq.{succ u_1} β b b')) -> Sort.{u_2}) (x._@.Init.Core.575184351._hygCtx._hyg.87 : Decidable (Eq.{succ u_1} β b b')), (forall (e₂ : Eq.{succ u_1} β b b'), motive (Decidable.isTrue (Eq.{succ u_1} β b b') e₂)) -> (forall (n₂ : Not (Eq.{succ u_1} β b b')), motive (Decidable.isFalse (Eq.{succ u_1} β b b') n₂)) -> (motive x._@.Init.Core.575184351._hygCtx._hyg.87)
-- (definition body omitted)

-- Stub: this file represents the declaration `instDecidableEqProd.match_1`.
-- In a full split, the body would be extracted from the environment.
