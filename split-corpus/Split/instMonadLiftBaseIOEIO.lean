import Mathlib

set_option pp.all true
-- spec: instMonadLiftBaseIOEIO : forall {ε : Type}, MonadLift.{0, 0, 0} BaseIO (EIO ε)
def instMonadLiftBaseIOEIO : forall {ε : Type}, MonadLift.{0, 0, 0} BaseIO (EIO ε) :=
  fun {ε : Type} => MonadLift.mk.{0, 0, 0} BaseIO (EIO ε) (fun {α._@.Init.System.IO.3654720459._hygCtx._hyg.17 : Type} => BaseIO.toEIO α._@.Init.System.IO.3654720459._hygCtx._hyg.17 ε)
