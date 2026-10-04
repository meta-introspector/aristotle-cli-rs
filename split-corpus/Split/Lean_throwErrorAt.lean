import Mathlib

set_option pp.all true
-- spec: Lean.throwErrorAt : forall {m : Type -> Type} {α : Type} [inst._@.Lean.Exception.2144675376._hygCtx._hyg.15 : Monad.{0, 0} m] [inst._@.Lean.Exception.2144675376._hygCtx._hyg.18 : Lean.MonadError m], Lean.Syntax -> Lean.MessageData -> (m α)
def Lean.throwErrorAt : forall {m : Type -> Type} {α : Type} [inst._@.Lean.Exception.2144675376._hygCtx._hyg.15 : Monad.{0, 0} m] [inst._@.Lean.Exception.2144675376._hygCtx._hyg.18 : Lean.MonadError m], Lean.Syntax -> Lean.MessageData -> (m α) :=
  fun {m : Type -> Type} {α : Type} [inst._@.Lean.Exception.2144675376._hygCtx._hyg.15 : Monad.{0, 0} m] [inst._@.Lean.Exception.2144675376._hygCtx._hyg.18 : Lean.MonadError m] (ref : Lean.Syntax) (msg : Lean.MessageData) => Lean.withRef m inst._@.Lean.Exception.2144675376._hygCtx._hyg.15 (Lean.MonadError.toMonadRef m inst._@.Lean.Exception.2144675376._hygCtx._hyg.18) α ref (Lean.throwError m α inst._@.Lean.Exception.2144675376._hygCtx._hyg.15 inst._@.Lean.Exception.2144675376._hygCtx._hyg.18 msg)
