import Mathlib

set_option pp.all true
-- spec: StateT.instMonadFunctor : forall (σ : Type.{u_1}) (m : Type.{u_1} -> Type.{u_2}), MonadFunctor.{u_1, u_2, max u_2 u_1} m (StateT.{u_1, u_2} σ m)
def StateT.instMonadFunctor : forall (σ : Type.{u_1}) (m : Type.{u_1} -> Type.{u_2}), MonadFunctor.{u_1, u_2, max u_2 u_1} m (StateT.{u_1, u_2} σ m) :=
  fun (σ : Type.{u_1}) (m : Type.{u_1} -> Type.{u_2}) => MonadFunctor.mk.{u_1, u_2, max u_2 u_1} m (StateT.{u_1, u_2} σ m) (fun {α._@.Init.Control.State.810043179._hygCtx._hyg.24 : Type.{u_1}} (f : forall {β : Type.{u_1}}, (m β) -> (m β)) (x : StateT.{u_1, u_2} σ m α._@.Init.Control.State.810043179._hygCtx._hyg.24) (s : σ) => f (Prod.{u_1, u_1} α._@.Init.Control.State.810043179._hygCtx._hyg.24 σ) (x s))
