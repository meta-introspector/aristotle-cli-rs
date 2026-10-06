import Mathlib

set_option pp.all true
-- spec: Or.casesOn : forall {a : Prop} {b : Prop} {motive : (Or a b) -> Prop} (t : Or a b), (forall (h : a), motive (Or.inl a b h)) -> (forall (h : b), motive (Or.inr a b h)) -> (motive t)
def Or.casesOn : forall {a : Prop} {b : Prop} {motive : (Or a b) -> Prop} (t : Or a b), (forall (h : a), motive (Or.inl a b h)) -> (forall (h : b), motive (Or.inr a b h)) -> (motive t) :=
  fun {a : Prop} {b : Prop} {motive : (Or a b) -> Prop} (t : Or a b) (inl : forall (h : a), motive (Or.inl a b h)) (inr : forall (h : b), motive (Or.inr a b h)) => Or.rec a b motive (fun (h : a) => inl h) (fun (h : b) => inr h) t
