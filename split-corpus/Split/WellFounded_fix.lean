import Mathlib

set_option pp.all true
-- spec: WellFounded.fix : forall {α : Sort.{u}} {C : α -> Sort.{v}} {r : α -> α -> Prop}, (WellFounded.{u} α r) -> (forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) -> (forall (x : α), C x)
def WellFounded.fix : forall {α : Sort.{u}} {C : α -> Sort.{v}} {r : α -> α -> Prop}, (WellFounded.{u} α r) -> (forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) -> (forall (x : α), C x) :=
  fun {α : Sort.{u}} {C : α -> Sort.{v}} {r : α -> α -> Prop} (hwf : WellFounded.{u} α r) (F : forall (x : α), (forall (y : α), (r y x) -> (C y)) -> (C x)) (x : α) => WellFounded.fixF.{u, v} α r C F x (WellFounded.apply.{u} α r hwf x)
