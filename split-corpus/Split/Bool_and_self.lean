import Mathlib

-- spec: theorem Bool.and_self : forall (b : Bool), Eq.{1} Bool (Bool.and b b) b
theorem Bool.and_self : forall (b : Bool), Eq.{1} Bool (Bool.and b b) b :=
  fun (b : Bool) => Bool.casesOn.{0} (fun (t._@.Init.SimpLemmas.2058600198._hygCtx._hyg.20 : Bool) => (Eq.{1} Bool b t._@.Init.SimpLemmas.2058600198._hygCtx._hyg.20) -> (Eq.{1} Bool (Bool.and b b) b)) b (fun (h._@.Init.SimpLemmas.2058600198._hygCtx._hyg.21 : Eq.{1} Bool b Bool.false) => Eq.ndrec.{0, 1} Bool Bool.false (fun (b : Bool) => Eq.{1} Bool (Bool.and b b) b) (Eq.refl.{1} Bool (Bool.and Bool.false Bool.false)) b (Eq.symm.{1} Bool b Bool.false h._@.Init.SimpLemmas.2058600198._hygCtx._hyg.21)) (fun (h._@.Init.SimpLemmas.2058600198._hygCtx._hyg.22 : Eq.{1} Bool b Bool.true) => Eq.ndrec.{0, 1} Bool Bool.true (fun (b : Bool) => Eq.{1} Bool (Bool.and b b) b) (Eq.refl.{1} Bool (Bool.and Bool.true Bool.true)) b (Eq.symm.{1} Bool b Bool.true h._@.Init.SimpLemmas.2058600198._hygCtx._hyg.22)) (Eq.refl.{1} Bool b)
