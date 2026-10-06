import Mathlib

set_option pp.all true
-- spec: Lean.instMonadAlwaysExceptStateRefT' : forall {m : Type -> Type} {ε : Type} {ω : Type} {σ : Type} [always : Lean.MonadAlwaysExcept.{0, 0} ε m], Lean.MonadAlwaysExcept.{0, 0} ε (StateRefT' ω σ m)
def Lean.instMonadAlwaysExceptStateRefT' : forall {m : Type -> Type} {ε : Type} {ω : Type} {σ : Type} [always : Lean.MonadAlwaysExcept.{0, 0} ε m], Lean.MonadAlwaysExcept.{0, 0} ε (StateRefT' ω σ m) :=
  fun {m : Type -> Type} {ε : Type} {ω : Type} {σ : Type} [always : Lean.MonadAlwaysExcept.{0, 0} ε m] => Lean.MonadAlwaysExcept.mk.{0, 0} ε (StateRefT' ω σ m) (have x._@.Lean.Util.Trace.1781180180._hygCtx._hyg.64 : MonadExceptOf.{0, 0, 0} ε m := Lean.MonadAlwaysExcept.except.{0, 0} ε m always; inferInstance.{2} (MonadExceptOf.{0, 0, 0} ε (StateRefT' ω σ m)) (StateRefT'.instMonadExceptOf.{0} ω σ m ε x._@.Lean.Util.Trace.1781180180._hygCtx._hyg.64))
