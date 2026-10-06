import Mathlib

set_option pp.all true
-- spec: Bool.casesOn : forall {motive : Bool -> Sort.{u}} (t : Bool), (motive Bool.false) -> (motive Bool.true) -> (motive t)
def Bool.casesOn : forall {motive : Bool -> Sort.{u}} (t : Bool), (motive Bool.false) -> (motive Bool.true) -> (motive t) :=
  fun {motive : Bool -> Sort.{u}} (t : Bool) (false : motive Bool.false) (true : motive Bool.true) => Bool.rec.{u} motive false true t
