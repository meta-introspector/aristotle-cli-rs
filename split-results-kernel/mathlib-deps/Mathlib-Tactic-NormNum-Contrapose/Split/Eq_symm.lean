import Mathlib

-- spec: theorem Eq.symm : forall {α : Sort.{u}} {a : α} {b : α}, (Eq.{u} α a b) -> (Eq.{u} α b a)
theorem Eq.symm : forall {α : Sort.{u}} {a : α} {b : α}, (Eq.{u} α a b) -> (Eq.{u} α b a) :=
  fun {α : Sort.{u}} {a : α} {b : α} (h : Eq.{u} α a b) => Eq.rec.{0, u} α a (fun (x._@.Init.Prelude.2345006592._hygCtx._hyg.14 : α) (h._@.Init.Prelude.2345006592._hygCtx._hyg.15 : Eq.{u} α a x._@.Init.Prelude.2345006592._hygCtx._hyg.14) => Eq.{u} α x._@.Init.Prelude.2345006592._hygCtx._hyg.14 a) (rfl.{u} α a) b h
