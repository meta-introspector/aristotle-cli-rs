import Mathlib

-- spec: theorem Or.resolve_left : forall {a : Prop} {b : Prop}, (Or a b) -> (Not a) -> b
theorem Or.resolve_left : forall {a : Prop} {b : Prop}, (Or a b) -> (Not a) -> b :=
  fun {a : Prop} {b : Prop} (h : Or a b) (na : Not a) => Or.elim a b b h (fun (x._@.Init.Prelude.2403819507._hygCtx._hyg.16 : a) => absurd.{0} a b x._@.Init.Prelude.2403819507._hygCtx._hyg.16 na) (id.{0} b)
