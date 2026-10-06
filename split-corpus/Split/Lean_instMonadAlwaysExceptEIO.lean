import Mathlib

set_option pp.all true
-- spec: Lean.instMonadAlwaysExceptEIO : forall {ε : Type}, Lean.MonadAlwaysExcept.{0, 0} ε (EIO ε)
def Lean.instMonadAlwaysExceptEIO : forall {ε : Type}, Lean.MonadAlwaysExcept.{0, 0} ε (EIO ε) :=
  fun {ε : Type} => Lean.MonadAlwaysExcept.mk.{0, 0} ε (EIO ε) (inferInstance.{2} (MonadExceptOf.{0, 0, 0} ε (EIO ε)) (instMonadExceptOfEIO ε))
