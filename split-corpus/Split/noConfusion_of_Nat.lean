import Mathlib

-- spec: theorem noConfusion_of_Nat : forall {α : Sort.{u}} (f : α -> Nat) {a : α} {b : α}, (Eq.{u} α a b) -> (Bool.rec.{1} (fun (x._@.Init.Prelude.3843949109._hygCtx._hyg.23 : Bool) => Prop) False True (Nat.beq (f a) (f b)))
theorem noConfusion_of_Nat : forall {α : Sort.{u}} (f : α -> Nat) {a : α} {b : α}, (Eq.{u} α a b) -> (Bool.rec.{1} (fun (x._@.Init.Prelude.3843949109._hygCtx._hyg.23 : Bool) => Prop) False True (Nat.beq (f a) (f b))) :=
  fun {α : Sort.{u}} (f : α -> Nat) {a : α} {b : α} (h : Eq.{u} α a b) => Eq.rec.{0, 1} Nat (f a) (fun (x._@.Init.Prelude.3843949109._hygCtx._hyg.35 : Nat) (h._@.Init.Prelude.3843949109._hygCtx._hyg.36 : Eq.{1} Nat (f a) x._@.Init.Prelude.3843949109._hygCtx._hyg.35) => Bool.rec.{1} (fun (x._@.Init.Prelude.3843949109._hygCtx._hyg.23 : Bool) => Prop) False True (Nat.beq (f a) x._@.Init.Prelude.3843949109._hygCtx._hyg.35)) (_private.Init.Prelude.0.noConfusion_of_Nat.aux (f a)) (f b) (congrArg.{u, 1} α Nat a b f h)
