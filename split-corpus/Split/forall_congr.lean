import Mathlib

-- spec: theorem forall_congr : forall {α : Sort.{u}} {p : α -> Prop} {q : α -> Prop}, (forall (a : α), Eq.{1} Prop (p a) (q a)) -> (Eq.{1} Prop (forall (a : α), p a) (forall (a : α), q a))
theorem forall_congr : forall {α : Sort.{u}} {p : α -> Prop} {q : α -> Prop}, (forall (a : α), Eq.{1} Prop (p a) (q a)) -> (Eq.{1} Prop (forall (a : α), p a) (forall (a : α), q a)) :=
  fun {α : Sort.{u}} {p : α -> Prop} {q : α -> Prop} (h : forall (a : α), Eq.{1} Prop (p a) (q a)) => Eq.rec.{0, max u 1} (α -> Prop) p (fun (x._@.Init.SimpLemmas.1060424076._hygCtx._hyg.45 : α -> Prop) (h._@.Init.SimpLemmas.1060424076._hygCtx._hyg.46 : Eq.{max 1 u} (α -> Prop) p x._@.Init.SimpLemmas.1060424076._hygCtx._hyg.45) => Eq.{1} Prop (forall (a : α), p a) (forall (a : α), x._@.Init.SimpLemmas.1060424076._hygCtx._hyg.45 a)) (rfl.{1} Prop (forall (a : α), p a)) q (funext.{u, 1} α (fun (x : α) => Prop) p q h)
