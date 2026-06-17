import Split.dite_cond_eq_true
import Split.of_eq_false
import Split.eq_false
import Split.congrArg
import Split.Decidable
import Split.dite
import Split.congr
import Split.True
import Split.eq_self
import Split.eq_true
import Split.of_eq_true
import Split.dite_cond_eq_false
import Split.Eq
import Split.Not
import Split.Eq_trans

-- apply_dite from environment
-- theorem apply_dite : forall {α : Sort.{u_1}} {β : Sort.{u_2}} (f : α -> β) (P : Prop) [inst._@.Init.ByCases.128310122._hygCtx._hyg.11 : Decidable P] (x : P -> α) (y : (Not P) -> α), Eq.{u_2} β (f (dite.{u_1} α P inst._@.Init.ByCases.128310122._hygCtx._hyg.11 x y)) (dite.{u_2} β P inst._@.Init.ByCases.128310122._hygCtx._hyg.11 (fun (h : P) => f (x h)) (fun (h : Not P) => f (y h)))

-- Stub: this file represents the declaration `apply_dite`.
-- In a full split, the body would be extracted from the environment.
