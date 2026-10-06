import Mathlib

set_option pp.all true
-- spec: Ordering.casesOn : forall {motive : Ordering -> Sort.{u}} (t : Ordering), (motive Ordering.lt) -> (motive Ordering.eq) -> (motive Ordering.gt) -> (motive t)
def Ordering.casesOn : forall {motive : Ordering -> Sort.{u}} (t : Ordering), (motive Ordering.lt) -> (motive Ordering.eq) -> (motive Ordering.gt) -> (motive t) :=
  fun {motive : Ordering -> Sort.{u}} (t : Ordering) (lt : motive Ordering.lt) (eq : motive Ordering.eq) (gt : motive Ordering.gt) => Ordering.rec.{u} motive lt eq gt t
