import Mathlib

set_option pp.all true
-- spec: Lean.Meta.withReducible : forall {n : Type -> Type.{u_1}} [inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.6 : MonadControlT.{0, 0, u_1} Lean.Meta.MetaM n] [inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.10 : Monad.{0, u_1} n] {α : Type}, (n α) -> (n α)
def Lean.Meta.withReducible : forall {n : Type -> Type.{u_1}} [inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.6 : MonadControlT.{0, 0, u_1} Lean.Meta.MetaM n] [inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.10 : Monad.{0, u_1} n] {α : Type}, (n α) -> (n α) :=
  fun {n : Type -> Type.{u_1}} [inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.6 : MonadControlT.{0, 0, u_1} Lean.Meta.MetaM n] [inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.10 : Monad.{0, u_1} n] {α : Type} (x : n α) => Lean.Meta.withTransparency.{u_1} n inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.6 inst._@.Lean.Meta.Basic.3251957638._hygCtx._hyg.10 α Lean.Meta.TransparencyMode.reducible x
