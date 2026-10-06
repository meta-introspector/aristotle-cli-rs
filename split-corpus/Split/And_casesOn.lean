import Mathlib

set_option pp.all true
-- spec: And.casesOn : forall {a : Prop} {b : Prop} {motive : (And a b) -> Sort.{u}} (t : And a b), (forall (left : a) (right : b), motive (And.intro a b left right)) -> (motive t)
def And.casesOn : forall {a : Prop} {b : Prop} {motive : (And a b) -> Sort.{u}} (t : And a b), (forall (left : a) (right : b), motive (And.intro a b left right)) -> (motive t) :=
  fun {a : Prop} {b : Prop} {motive : (And a b) -> Sort.{u}} (t : And a b) (intro : forall (left : a) (right : b), motive (And.intro a b left right)) => And.rec.{u} a b motive (fun (left : a) (right : b) => intro left right) t
