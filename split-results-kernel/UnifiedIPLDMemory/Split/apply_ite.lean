import Split.apply_dite
import Split.Decidable
import Split.Eq
import Split.Not
import Split.ite

-- apply_ite from environment
-- theorem apply_ite : forall {α : Sort.{u_1}} {β : Sort.{u_2}} (f : α -> β) (P : Prop) [inst._@.Init.ByCases.1897990110._hygCtx._hyg.11 : Decidable P] (x : α) (y : α), Eq.{u_2} β (f (ite.{u_1} α P inst._@.Init.ByCases.1897990110._hygCtx._hyg.11 x y)) (ite.{u_2} β P inst._@.Init.ByCases.1897990110._hygCtx._hyg.11 (f x) (f y))

-- Stub: this file represents the declaration `apply_ite`.
-- In a full split, the body would be extracted from the environment.
