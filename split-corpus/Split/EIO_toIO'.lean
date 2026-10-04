import Mathlib

set_option pp.all true
-- spec: EIO.toIO' : forall {ε : Type} {α : Type}, (EIO ε α) -> (IO (Except.{0, 0} ε α))
def EIO.toIO' : forall {ε : Type} {α : Type}, (EIO ε α) -> (IO (Except.{0, 0} ε α)) :=
  fun {ε : Type} {α : Type} (act : EIO ε α) => liftM.{0, 0, 0} BaseIO (EIO IO.Error) (instMonadLiftTOfMonadLift.{0, 0, 0, 0} BaseIO BaseIO (EIO IO.Error) (instMonadLiftBaseIOEIO IO.Error) (instMonadLiftT.{0, 0} BaseIO)) (Except.{0, 0} ε α) (EIO.toBaseIO ε α act)
