import Mathlib

-- spec: theorem of_decide_eq_false : forall {p : Prop} [inst : Decidable p], (Eq.{1} Bool (Decidable.decide p inst) Bool.false) -> (Not p)
theorem of_decide_eq_false : forall {p : Prop} [inst : Decidable p], (Eq.{1} Bool (Decidable.decide p inst) Bool.false) -> (Not p) :=
  fun {p : Prop} [inst : Decidable p] (h : Eq.{1} Bool (Decidable.decide p inst) Bool.false) => _private.Init.Prelude.0.of_decide_eq_false.match_1_1 p (fun (inst._@.Init.Prelude.1516502874._hygCtx._hyg.21 : Decidable p) => Not p) inst (fun (h₁ : p) => absurd.{0} (Eq.{1} Bool (Decidable.decide p inst) Bool.false) (Not p) h (ne_false_of_eq_true (Decidable.decide p inst) (decide_eq_true p inst h₁))) (fun (h₁ : Not p) => h₁)
