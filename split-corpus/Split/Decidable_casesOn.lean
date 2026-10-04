import Mathlib

set_option pp.all true
-- spec: Decidable.casesOn : forall {p : Prop} {motive : (Decidable p) -> Sort.{u}} (t : Decidable p), (forall (h : Not p), motive (Decidable.isFalse p h)) -> (forall (h : p), motive (Decidable.isTrue p h)) -> (motive t)
def Decidable.casesOn : forall {p : Prop} {motive : (Decidable p) -> Sort.{u}} (t : Decidable p), (forall (h : Not p), motive (Decidable.isFalse p h)) -> (forall (h : p), motive (Decidable.isTrue p h)) -> (motive t) :=
  fun {p : Prop} {motive : (Decidable p) -> Sort.{u}} (t : Decidable p) (isFalse : forall (h : Not p), motive (Decidable.isFalse p h)) (isTrue : forall (h : p), motive (Decidable.isTrue p h)) => Decidable.rec.{u} p motive (fun (h : Not p) => isFalse h) (fun (h : p) => isTrue h) t
