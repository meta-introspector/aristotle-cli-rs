import Mathlib

set_option pp.all true
-- spec: instMonadBaseIO : Monad.{0, 0} BaseIO
def instMonadBaseIO : Monad.{0, 0} BaseIO :=
  Monad.mk.{0, 0} BaseIO (Applicative.mk.{0, 0} BaseIO (Functor.mk.{0, 0} BaseIO instMonadBaseIO._aux_1 instMonadBaseIO._aux_3) (Pure.mk.{0, 0} BaseIO instMonadBaseIO._aux_5) (Seq.mk.{0, 0} BaseIO instMonadBaseIO._aux_7) (SeqLeft.mk.{0, 0} BaseIO instMonadBaseIO._aux_9) (SeqRight.mk.{0, 0} BaseIO instMonadBaseIO._aux_11)) (Bind.mk.{0, 0} BaseIO instMonadBaseIO._aux_13)
