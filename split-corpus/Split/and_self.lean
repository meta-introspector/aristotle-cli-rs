import Mathlib

-- spec: theorem and_self : forall (p : Prop), Eq.{1} Prop (And p p) p
theorem and_self : forall (p : Prop), Eq.{1} Prop (And p p) p :=
  fun (p : Prop) => propext (And p p) p (Iff.intro (And p p) p (fun (x._@.Init.SimpLemmas.2058600197._hygCtx._hyg.16 : And p p) => And.left p p x._@.Init.SimpLemmas.2058600197._hygCtx._hyg.16) (fun (h : p) => And.intro p p h h))
