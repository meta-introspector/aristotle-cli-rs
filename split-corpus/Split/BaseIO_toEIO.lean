import Mathlib

set_option pp.all true
-- spec: BaseIO.toEIO : forall {α : Type} {ε : Type}, (BaseIO α) -> (EIO ε α)
def BaseIO.toEIO : forall {α : Type} {ε : Type}, (BaseIO α) -> (EIO ε α) :=
  fun {α : Type} {ε : Type} (act : BaseIO α) (s : Void IO.RealWorld) => _private.Init.System.IO.0.BaseIO.toEIO.match_1.{1} α (fun (x._@.Init.System.IO.408276792._hygCtx._hyg.24 : ST.Out IO.RealWorld α) => EST.Out ε IO.RealWorld α) (act s) (fun (a : α) (s : Void IO.RealWorld) => EST.Out.ok ε IO.RealWorld α a s)
