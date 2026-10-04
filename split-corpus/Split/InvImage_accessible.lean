import Mathlib

-- spec: theorem InvImage.accessible : forall {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} {a : α} (f : α -> β), (Acc.{v} β r (f a)) -> (Acc.{u} α (InvImage.{u, v} α β r f) a)
theorem InvImage.accessible : forall {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} {a : α} (f : α -> β), (Acc.{v} β r (f a)) -> (Acc.{u} α (InvImage.{u, v} α β r f) a) :=
  fun {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} {a : α} (f : α -> β) (ac : Acc.{v} β r (f a)) => InvImage.accAux.{u, v} α β r f (f a) ac a (rfl.{v} β (f a))
