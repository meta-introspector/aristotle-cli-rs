import Mathlib

set_option pp.all true
-- spec: Lean.Meta.withMCtx : forall {n : Type -> Type.{u_1}} [inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.6 : MonadControlT.{0, 0, u_1} Lean.Meta.MetaM n] [inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.10 : Monad.{0, u_1} n] {α : Type}, Lean.MetavarContext -> (n α) -> (n α)
def Lean.Meta.withMCtx : forall {n : Type -> Type.{u_1}} [inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.6 : MonadControlT.{0, 0, u_1} Lean.Meta.MetaM n] [inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.10 : Monad.{0, u_1} n] {α : Type}, Lean.MetavarContext -> (n α) -> (n α) :=
  fun {n : Type -> Type.{u_1}} [inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.6 : MonadControlT.{0, 0, u_1} Lean.Meta.MetaM n] [inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.10 : Monad.{0, u_1} n] {α : Type} (mctx : Lean.MetavarContext) => Lean.Meta.mapMetaM.{u_1} n inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.6 inst._@.Lean.Meta.Basic.297701396._hygCtx._hyg.10 (fun {α._@.Lean.Meta.Basic.297701396._hygCtx._hyg.27 : Type} => _private.Lean.Meta.Basic.0.Lean.Meta.withMCtxImp α._@.Lean.Meta.Basic.297701396._hygCtx._hyg.27 mctx) α
