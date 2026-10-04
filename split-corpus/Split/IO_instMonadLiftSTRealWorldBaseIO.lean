import Mathlib

set_option pp.all true
-- spec: IO.instMonadLiftSTRealWorldBaseIO : MonadLift.{0, 0, 0} (ST IO.RealWorld) BaseIO
def IO.instMonadLiftSTRealWorldBaseIO : MonadLift.{0, 0, 0} (ST IO.RealWorld) BaseIO :=
  MonadLift.mk.{0, 0, 0} (ST IO.RealWorld) BaseIO (fun {α._@.Init.System.IO.4073814663._hygCtx._hyg.15 : Type} (mx : ST IO.RealWorld α._@.Init.System.IO.4073814663._hygCtx._hyg.15) (s : Void IO.RealWorld) => IO.instMonadLiftSTRealWorldBaseIO.match_1.{1} α._@.Init.System.IO.4073814663._hygCtx._hyg.15 (fun (x._@.Init.System.IO.4073814663._hygCtx._hyg.28 : ST.Out IO.RealWorld α._@.Init.System.IO.4073814663._hygCtx._hyg.15) => ST.Out IO.RealWorld α._@.Init.System.IO.4073814663._hygCtx._hyg.15) (mx s) (fun (s : α._@.Init.System.IO.4073814663._hygCtx._hyg.15) (a : Void IO.RealWorld) => ST.Out.mk IO.RealWorld α._@.Init.System.IO.4073814663._hygCtx._hyg.15 s a))
