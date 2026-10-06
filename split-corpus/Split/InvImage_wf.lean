import Mathlib

-- spec: theorem InvImage.wf : forall {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} (f : α -> β), (WellFounded.{v} β r) -> (WellFounded.{u} α (InvImage.{u, v} α β r f))
theorem InvImage.wf : forall {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} (f : α -> β), (WellFounded.{v} β r) -> (WellFounded.{u} α (InvImage.{u, v} α β r f)) :=
  fun {α : Sort.{u}} {β : Sort.{v}} {r : β -> β -> Prop} (f : α -> β) (h : WellFounded.{v} β r) => WellFounded.intro.{u} α (InvImage.{u, v} α β r f) (fun (a : α) => InvImage.accessible.{u, v} α β r a f (WellFounded.apply.{v} β r h (f a)))
