import Mathlib

set_option pp.all true
-- spec: instMonadFinallyEIO : forall {ε : Type}, MonadFinally.{0, 0} (EIO ε)
def instMonadFinallyEIO : forall {ε : Type}, MonadFinally.{0, 0} (EIO ε) :=
  fun {ε : Type} => MonadFinally.mk.{0, 0} (EIO ε) (instMonadFinallyEIO._aux_1 ε)
