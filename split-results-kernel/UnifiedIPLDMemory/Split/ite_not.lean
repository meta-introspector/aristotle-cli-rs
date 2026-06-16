import Split.instDecidableNot
import Split.dite_not
import Split.Decidable
import Split.Eq
import Split.Not
import Split.ite

-- ite_not from environment
-- theorem ite_not : forall {α : Sort.{u_1}} (p : Prop) [inst._@.Init.PropLemmas.2336043796._hygCtx._hyg.8 : Decidable p] (x : α) (y : α), Eq.{u_1} α (ite.{u_1} α (Not p) (instDecidableNot p inst._@.Init.PropLemmas.2336043796._hygCtx._hyg.8) x y) (ite.{u_1} α p inst._@.Init.PropLemmas.2336043796._hygCtx._hyg.8 y x)

-- Stub: this file represents the declaration `ite_not`.
-- In a full split, the body would be extracted from the environment.
