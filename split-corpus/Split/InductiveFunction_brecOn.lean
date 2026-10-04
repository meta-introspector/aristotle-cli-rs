import Mathlib

set_option pp.all true
-- spec: InductiveFunction.brecOn : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (forall (t : InductiveFunction), (InductiveFunction.below.{u} motive t) -> (motive t)) -> (motive t)
def InductiveFunction.brecOn : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (forall (t : InductiveFunction), (InductiveFunction.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction) (F_1 : forall (t : InductiveFunction), (InductiveFunction.below.{u} motive t) -> (motive t)) => (InductiveFunction.brecOn.go.{u} motive t F_1).1
