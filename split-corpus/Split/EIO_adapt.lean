import Mathlib

set_option pp.all true
-- spec: EIO.adapt : forall {ε : Type} {ε' : Type} {α : Type}, (ε -> ε') -> (EIO ε α) -> (EIO ε' α)
def EIO.adapt : forall {ε : Type} {ε' : Type} {α : Type}, (ε -> ε') -> (EIO ε α) -> (EIO ε' α) :=
  fun {ε : Type} {ε' : Type} {α : Type} (f : ε -> ε') (m : EIO ε α) (s : Void IO.RealWorld) => _private.Init.System.IO.0.EIO.toBaseIO.match_1.{1} ε α (fun (x._@.Init.System.IO.900904307._hygCtx._hyg.33 : EST.Out ε IO.RealWorld α) => EST.Out ε' IO.RealWorld α) (m s) (fun (a : α) (s : Void IO.RealWorld) => EST.Out.ok ε' IO.RealWorld α a s) (fun (e : ε) (s : Void IO.RealWorld) => EST.Out.error ε' IO.RealWorld α (f e) s)
