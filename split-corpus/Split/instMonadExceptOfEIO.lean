import Mathlib

set_option pp.all true
-- spec: instMonadExceptOfEIO : forall {ε : Type}, MonadExceptOf.{0, 0, 0} ε (EIO ε)
def instMonadExceptOfEIO : forall {ε : Type}, MonadExceptOf.{0, 0, 0} ε (EIO ε) :=
  fun {ε : Type} => MonadExceptOf.mk.{0, 0, 0} ε (EIO ε) (instMonadExceptOfEIO._aux_1 ε) (instMonadExceptOfEIO._aux_3 ε)
