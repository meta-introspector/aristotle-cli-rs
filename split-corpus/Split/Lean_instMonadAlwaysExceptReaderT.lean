import Mathlib

set_option pp.all true
-- spec: Lean.instMonadAlwaysExceptReaderT : forall {m : Type -> Type} {ε : Type} {ρ : Type} [always : Lean.MonadAlwaysExcept.{0, 0} ε m], Lean.MonadAlwaysExcept.{0, 0} ε (ReaderT.{0, 0} ρ m)
def Lean.instMonadAlwaysExceptReaderT : forall {m : Type -> Type} {ε : Type} {ρ : Type} [always : Lean.MonadAlwaysExcept.{0, 0} ε m], Lean.MonadAlwaysExcept.{0, 0} ε (ReaderT.{0, 0} ρ m) :=
  fun {m : Type -> Type} {ε : Type} {ρ : Type} [always : Lean.MonadAlwaysExcept.{0, 0} ε m] => Lean.MonadAlwaysExcept.mk.{0, 0} ε (ReaderT.{0, 0} ρ m) (have x._@.Lean.Util.Trace.2466024376._hygCtx._hyg.53 : MonadExceptOf.{0, 0, 0} ε m := Lean.MonadAlwaysExcept.except.{0, 0} ε m always; inferInstance.{2} (MonadExceptOf.{0, 0, 0} ε (ReaderT.{0, 0} ρ m)) (ReaderT.instMonadExceptOf.{0, 0, 0} ρ m ε x._@.Lean.Util.Trace.2466024376._hygCtx._hyg.53))
