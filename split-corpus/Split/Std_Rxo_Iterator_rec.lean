import Mathlib

-- spec: recursor Std.Rxo.Iterator.rec : forall {α : Type.{u}} {motive : (Std.Rxo.Iterator.{u} α) -> Sort.{u_1}}, (forall (next : Option.{u} α) (upperBound : α), motive (Std.Rxo.Iterator.mk.{u} α next upperBound)) -> (forall (t : Std.Rxo.Iterator.{u} α), motive t)
