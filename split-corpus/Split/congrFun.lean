import Mathlib

-- spec: theorem congrFun : forall {α : Sort.{u}} {β : α -> Sort.{v}} {f : forall (x : α), β x} {g : forall (x : α), β x}, (Eq.{imax u v} (forall (x : α), β x) f g) -> (forall (a : α), Eq.{v} (β a) (f a) (g a))
theorem congrFun : forall {α : Sort.{u}} {β : α -> Sort.{v}} {f : forall (x : α), β x} {g : forall (x : α), β x}, (Eq.{imax u v} (forall (x : α), β x) f g) -> (forall (a : α), Eq.{v} (β a) (f a) (g a)) :=
  fun {α : Sort.{u}} {β : α -> Sort.{v}} {f : forall (x : α), β x} {g : forall (x : α), β x} (h : Eq.{imax u v} (forall (x : α), β x) f g) (a : α) => Eq.rec.{0, imax u v} (forall (x : α), β x) f (fun (x._@.Init.Prelude.1652506524._hygCtx._hyg.30 : forall (x : α), β x) (h._@.Init.Prelude.1652506524._hygCtx._hyg.31 : Eq.{imax u v} (forall (x : α), β x) f x._@.Init.Prelude.1652506524._hygCtx._hyg.30) => Eq.{v} (β a) (f a) (x._@.Init.Prelude.1652506524._hygCtx._hyg.30 a)) (rfl.{v} (β a) (f a)) g h
