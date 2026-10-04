import Mathlib

set_option pp.all true
-- spec: WellFounded.fixF : forall {α : Sort.{u}} {r : α -> α -> Prop} {C : α -> Sort.{v}}, (forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) -> (forall (x : α), (Acc.{u} α r x) -> (C x))
def WellFounded.fixF : forall {α : Sort.{u}} {r : α -> α -> Prop} {C : α -> Sort.{v}}, (forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) -> (forall (x : α), (Acc.{u} α r x) -> (C x)) :=
  fun {α : Sort.{u}} {r : α -> α -> Prop} {C : α -> Sort.{v}} (F : forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) (x : α) (a : Acc.{u} α r x) => Acc.rec.{v, u} α r (fun (x : α) (a : Acc.{u} α r x) => C x) (fun (x₁ : α) (h._@.Init.WF.916566324._hygCtx._hyg.41 : forall (y : α), (r y x₁) -> (Acc.{u} α r y)) (ih : forall (y : α), (r y x₁) -> (C y)) => F x₁ ih) x a
