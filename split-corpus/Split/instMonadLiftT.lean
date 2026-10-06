import Mathlib

set_option pp.all true
-- spec: instMonadLiftT : forall (m : Type.{u_1} -> Type.{u_2}), MonadLiftT.{u_1, u_2, u_2} m m
def instMonadLiftT : forall (m : Type.{u_1} -> Type.{u_2}), MonadLiftT.{u_1, u_2, u_2} m m :=
  fun (m : Type.{u_1} -> Type.{u_2}) => MonadLiftT.mk.{u_1, u_2, u_2} m m (fun {α._@.Init.Prelude.51052603._hygCtx._hyg.13 : Type.{u_1}} (x : m α._@.Init.Prelude.51052603._hygCtx._hyg.13) => x)
