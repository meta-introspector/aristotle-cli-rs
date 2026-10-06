import Mathlib

set_option pp.all true
-- spec: instAlternativeOption : Alternative.{u_1, u_1} Option.{u_1}
def instAlternativeOption : Alternative.{u_1, u_1} Option.{u_1} :=
  Alternative.mk.{u_1, u_1} Option.{u_1} (Monad.toApplicative.{u_1, u_1} Option.{u_1} instMonadOption.{u_1}) (fun {α._@.Init.Data.Option.Basic.180119320._hygCtx._hyg.8 : Type.{u_1}} => Option.none.{u_1} α._@.Init.Data.Option.Basic.180119320._hygCtx._hyg.8) (fun {α._@.Init.Data.Option.Basic.180119320._hygCtx._hyg.10 : Type.{u_1}} => Option.orElse.{u_1} α._@.Init.Data.Option.Basic.180119320._hygCtx._hyg.10)
