import Mathlib

set_option pp.all true
-- spec: EIO.toBaseIO : forall {ε : Type} {α : Type}, (EIO ε α) -> (BaseIO (Except.{0, 0} ε α))
def EIO.toBaseIO : forall {ε : Type} {α : Type}, (EIO ε α) -> (BaseIO (Except.{0, 0} ε α)) :=
  fun {ε : Type} {α : Type} (act : EIO ε α) (s : Void IO.RealWorld) => _private.Init.System.IO.0.EIO.toBaseIO.match_1.{1} ε α (fun (x._@.Init.System.IO.686954362._hygCtx._hyg.27 : EST.Out ε IO.RealWorld α) => ST.Out IO.RealWorld (Except.{0, 0} ε α)) (act s) (fun (a : α) (s : Void IO.RealWorld) => ST.Out.mk IO.RealWorld (Except.{0, 0} ε α) (Except.ok.{0, 0} ε α a) s) (fun (ex : ε) (s : Void IO.RealWorld) => ST.Out.mk IO.RealWorld (Except.{0, 0} ε α) (Except.error.{0, 0} ε α ex) s)
