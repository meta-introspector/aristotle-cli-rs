import Mathlib

set_option pp.all true
-- spec: monadFunctorRefl : forall (m : Type.{u_1} -> Type.{u_2}), MonadFunctorT.{u_1, u_2, u_2} m m
def monadFunctorRefl : forall (m : Type.{u_1} -> Type.{u_2}), MonadFunctorT.{u_1, u_2, u_2} m m :=
  fun (m : Type.{u_1} -> Type.{u_2}) => MonadFunctorT.mk.{u_1, u_2, u_2} m m (fun {α._@.Init.Prelude.3473311419._hygCtx._hyg.13 : Type.{u_1}} (f : forall {β : Type.{u_1}}, (m β) -> (m β)) => f α._@.Init.Prelude.3473311419._hygCtx._hyg.13)
