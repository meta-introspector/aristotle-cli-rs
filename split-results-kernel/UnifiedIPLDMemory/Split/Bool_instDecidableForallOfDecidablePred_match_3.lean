import Split.Decidable_isTrue
import Split.Decidable_casesOn
import Split.Decidable
import Split.Bool_true
import Split.Bool
import Split.Decidable_isFalse
import Split.Bool_false
import Split.Not

-- Bool.instDecidableForallOfDecidablePred.match_3 from environment
-- def Bool.instDecidableForallOfDecidablePred.match_3 : forall (p : Bool -> Prop) (motive : (Decidable (p Bool.true)) -> (Decidable (p Bool.false)) -> Sort.{u_1}) (x._@.Init.Data.Bool.1519501257._hygCtx._hyg.28 : Decidable (p Bool.true)) (x._@.Init.Data.Bool.1519501257._hygCtx._hyg.30 : Decidable (p Bool.false)), (forall (ht : Not (p Bool.true)) (x._@.Init.Data.Bool.1519501257._hygCtx._hyg.39 : Decidable (p Bool.false)), motive (Decidable.isFalse (p Bool.true) ht) x._@.Init.Data.Bool.1519501257._hygCtx._hyg.39) -> (forall (x._@.Init.Data.Bool.1519501257._hygCtx._hyg.58 : Decidable (p Bool.true)) (hf : Not (p Bool.false)), motive x._@.Init.Data.Bool.1519501257._hygCtx._hyg.58 (Decidable.isFalse (p Bool.false) hf)) -> (forall (ht : p Bool.true) (hf : p Bool.false), motive (Decidable.isTrue (p Bool.true) ht) (Decidable.isTrue (p Bool.false) hf)) -> (motive x._@.Init.Data.Bool.1519501257._hygCtx._hyg.28 x._@.Init.Data.Bool.1519501257._hygCtx._hyg.30)
-- (definition body omitted)

-- Stub: this file represents the declaration `Bool.instDecidableForallOfDecidablePred.match_3`.
-- In a full split, the body would be extracted from the environment.
