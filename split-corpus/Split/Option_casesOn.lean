import Mathlib

set_option pp.all true
-- spec: Option.casesOn : forall {α : Type.{u}} {motive : (Option.{u} α) -> Sort.{u_1}} (t : Option.{u} α), (motive (Option.none.{u} α)) -> (forall (val : α), motive (Option.some.{u} α val)) -> (motive t)
def Option.casesOn : forall {α : Type.{u}} {motive : (Option.{u} α) -> Sort.{u_1}} (t : Option.{u} α), (motive (Option.none.{u} α)) -> (forall (val : α), motive (Option.some.{u} α val)) -> (motive t) :=
  fun {α : Type.{u}} {motive : (Option.{u} α) -> Sort.{u_1}} (t : Option.{u} α) (none : motive (Option.none.{u} α)) (some : forall (val : α), motive (Option.some.{u} α val)) => Option.rec.{u_1, u} α motive none (fun (val : α) => some val) t
