import Mathlib

-- spec: theorem Or.resolve_right : forall {a : Prop} {b : Prop}, (Or a b) -> (Not b) -> a
theorem Or.resolve_right : forall {a : Prop} {b : Prop}, (Or a b) -> (Not b) -> a :=
  fun {a : Prop} {b : Prop} (h : Or a b) (nb : Not b) => Or.elim a b a h (id.{0} a) (fun (x._@.Init.Prelude.647470110._hygCtx._hyg.17 : b) => absurd.{0} b a x._@.Init.Prelude.647470110._hygCtx._hyg.17 nb)
