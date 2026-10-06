import Mathlib

-- spec: theorem Or.elim : forall {a : Prop} {b : Prop} {c : Prop}, (Or a b) -> (a -> c) -> (b -> c) -> c
theorem Or.elim : forall {a : Prop} {b : Prop} {c : Prop}, (Or a b) -> (a -> c) -> (b -> c) -> c :=
  fun {a : Prop} {b : Prop} {c : Prop} (h : Or a b) (left : a -> c) (right : b -> c) => _private.Init.Prelude.0.Or.elim.match_1_1 a b (fun (h._@.Init.Prelude.2135250727._hygCtx._hyg.23 : Or a b) => c) h (fun (h : a) => left h) (fun (h : b) => right h)
