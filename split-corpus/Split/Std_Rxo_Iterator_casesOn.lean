import Mathlib

set_option pp.all true
-- spec: Std.Rxo.Iterator.casesOn : forall {α : Type.{u}} {motive : (Std.Rxo.Iterator.{u} α) -> Sort.{u_1}} (t : Std.Rxo.Iterator.{u} α), (forall (next : Option.{u} α) (upperBound : α), motive (Std.Rxo.Iterator.mk.{u} α next upperBound)) -> (motive t)
def Std.Rxo.Iterator.casesOn : forall {α : Type.{u}} {motive : (Std.Rxo.Iterator.{u} α) -> Sort.{u_1}} (t : Std.Rxo.Iterator.{u} α), (forall (next : Option.{u} α) (upperBound : α), motive (Std.Rxo.Iterator.mk.{u} α next upperBound)) -> (motive t) :=
  fun {α : Type.{u}} {motive : (Std.Rxo.Iterator.{u} α) -> Sort.{u_1}} (t : Std.Rxo.Iterator.{u} α) (mk : forall (next : Option.{u} α) (upperBound : α), motive (Std.Rxo.Iterator.mk.{u} α next upperBound)) => Std.Rxo.Iterator.rec.{u_1, u} α motive (fun (next : Option.{u} α) (upperBound : α) => mk next upperBound) t
