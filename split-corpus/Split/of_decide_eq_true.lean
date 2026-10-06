import Mathlib

-- spec: theorem of_decide_eq_true : forall {p : Prop} [inst : Decidable p], (Eq.{1} Bool (Decidable.decide p inst) Bool.true) -> p
theorem of_decide_eq_true : forall {p : Prop} [inst : Decidable p], (Eq.{1} Bool (Decidable.decide p inst) Bool.true) -> p :=
  fun {p : Prop} [inst : Decidable p] (h : Eq.{1} Bool (Decidable.decide p inst) Bool.true) => _private.Init.Prelude.0.of_decide_eq_true.match_1_1 p (fun (inst._@.Init.Prelude.1224138662._hygCtx._hyg.20 : Decidable p) => p) inst (fun (h₁ : p) => h₁) (fun (h₁ : Not p) => absurd.{0} (Eq.{1} Bool (Decidable.decide p inst) Bool.true) p h (ne_true_of_eq_false (Decidable.decide p inst) (decide_eq_false p inst h₁)))
