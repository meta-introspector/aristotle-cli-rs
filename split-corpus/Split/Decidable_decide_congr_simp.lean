import Mathlib

-- spec: theorem Decidable.decide.congr_simp : forall (p : Prop) (p_1 : Prop), (Eq.{1} Prop p p_1) -> (forall {h : Decidable p} [h_1 : Decidable p_1], Eq.{1} Bool (Decidable.decide p h) (Decidable.decide p_1 h_1))
theorem Decidable.decide.congr_simp : forall (p : Prop) (p_1 : Prop), (Eq.{1} Prop p p_1) -> (forall {h : Decidable p} [h_1 : Decidable p_1], Eq.{1} Bool (Decidable.decide p h) (Decidable.decide p_1 h_1)) :=
  fun (p : Prop) (p_1 : Prop) (e_p : Eq.{1} Prop p p_1) => Eq.rec.{0, 1} Prop p (fun (p_1 : Prop) (e_p : Eq.{1} Prop p p_1) => forall {h : Decidable p} [h_1 : Decidable p_1], Eq.{1} Bool (Decidable.decide p h) (Decidable.decide p_1 h_1)) (fun {h : Decidable p} [h_1 : Decidable p] => Eq.ndrec.{0, 1} (Decidable p) h (fun [h_1 : Decidable p] => Eq.{1} Bool (Decidable.decide p h) (Decidable.decide p h_1)) (Eq.refl.{1} Bool (Decidable.decide p h)) h_1 (Subsingleton.elim.{1} (Decidable p) (instSubsingletonDecidable p) h h_1)) p_1 e_p
