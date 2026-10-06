import Mathlib

set_option pp.all true
-- spec: ReaderT.instMonadFunctor : forall (ρ : Type.{u_1}) (m : Type.{u_1} -> Type.{u_2}), MonadFunctor.{u_1, u_2, max u_2 u_1} m (ReaderT.{u_1, u_2} ρ m)
def ReaderT.instMonadFunctor : forall (ρ : Type.{u_1}) (m : Type.{u_1} -> Type.{u_2}), MonadFunctor.{u_1, u_2, max u_2 u_1} m (ReaderT.{u_1, u_2} ρ m) :=
  fun (ρ : Type.{u_1}) (m : Type.{u_1} -> Type.{u_2}) => MonadFunctor.mk.{u_1, u_2, max u_2 u_1} m (ReaderT.{u_1, u_2} ρ m) (fun {α._@.Init.Prelude.810043179._hygCtx._hyg.22 : Type.{u_1}} (f : forall {β : Type.{u_1}}, (m β) -> (m β)) (x : ReaderT.{u_1, u_2} ρ m α._@.Init.Prelude.810043179._hygCtx._hyg.22) (ctx : ρ) => f α._@.Init.Prelude.810043179._hygCtx._hyg.22 (x ctx))
