import Mathlib

-- spec: theorem congrFun' : forall {α : Sort.{u}} {β : Sort.{v}} {f : α -> β} {g : α -> β}, (Eq.{imax u v} (α -> β) f g) -> (forall (a : α), Eq.{v} β (f a) (g a))
theorem congrFun' : forall {α : Sort.{u}} {β : Sort.{v}} {f : α -> β} {g : α -> β}, (Eq.{imax u v} (α -> β) f g) -> (forall (a : α), Eq.{v} β (f a) (g a)) :=
  fun {α : Sort.{u}} {β : Sort.{v}} {f : α -> β} {g : α -> β} (h : Eq.{imax u v} (α -> β) f g) (a : α) => Eq.rec.{0, imax u v} (α -> β) f (fun (x._@.Init.Prelude.2891185530._hygCtx._hyg.26 : α -> β) (h._@.Init.Prelude.2891185530._hygCtx._hyg.27 : Eq.{imax u v} (α -> β) f x._@.Init.Prelude.2891185530._hygCtx._hyg.26) => Eq.{v} β (f a) (x._@.Init.Prelude.2891185530._hygCtx._hyg.26 a)) (rfl.{v} β (f a)) g h
