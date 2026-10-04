import Mathlib

set_option pp.all true
-- spec: instMonadEIO : forall {ε : Type}, Monad.{0, 0} (EIO ε)
def instMonadEIO : forall {ε : Type}, Monad.{0, 0} (EIO ε) :=
  fun {ε : Type} => Monad.mk.{0, 0} (EIO ε) (Applicative.mk.{0, 0} (EIO ε) (Functor.mk.{0, 0} (EIO ε) (instMonadEIO._aux_1 ε) (instMonadEIO._aux_3 ε)) (Pure.mk.{0, 0} (EIO ε) (instMonadEIO._aux_5 ε)) (Seq.mk.{0, 0} (EIO ε) (instMonadEIO._aux_7 ε)) (SeqLeft.mk.{0, 0} (EIO ε) (instMonadEIO._aux_9 ε)) (SeqRight.mk.{0, 0} (EIO ε) (instMonadEIO._aux_11 ε))) (Bind.mk.{0, 0} (EIO ε) (instMonadEIO._aux_13 ε))
