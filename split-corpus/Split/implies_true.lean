import Mathlib

-- spec: theorem implies_true : forall (α : Sort.{u}), Eq.{1} Prop (α -> True) True
theorem implies_true : forall (α : Sort.{u}), Eq.{1} Prop (α -> True) True :=
  fun (α : Sort.{u}) => eq_true (α -> True) (fun (x._@.Init.SimpLemmas.2303878612._hygCtx._hyg.13 : α) => trivial)
