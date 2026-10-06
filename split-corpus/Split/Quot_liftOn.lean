import Mathlib

set_option pp.all true
-- spec: Quot.liftOn : forall {α : Sort.{u}} {β : Sort.{v}} {r : α -> α -> Prop}, (Quot.{u} α r) -> (forall (f : α -> β), (forall (a : α) (b : α), (r a b) -> (Eq.{v} β (f a) (f b))) -> β)
def Quot.liftOn : forall {α : Sort.{u}} {β : Sort.{v}} {r : α -> α -> Prop}, (Quot.{u} α r) -> (forall (f : α -> β), (forall (a : α) (b : α), (r a b) -> (Eq.{v} β (f a) (f b))) -> β) :=
  fun {α : Sort.{u}} {β : Sort.{v}} {r : α -> α -> Prop} (q : Quot.{u} α r) (f : α -> β) (c : forall (a : α) (b : α), (r a b) -> (Eq.{v} β (f a) (f b))) => Quot.lift.{u, v} α r β f c q
