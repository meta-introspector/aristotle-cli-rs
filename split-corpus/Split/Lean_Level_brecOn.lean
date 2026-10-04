import Mathlib

set_option pp.all true
-- spec: Lean.Level.brecOn : forall {motive : Lean.Level -> Sort.{u}} (t : Lean.Level), (forall (t : Lean.Level), (Lean.Level.below.{u} motive t) -> (motive t)) -> (motive t)
def Lean.Level.brecOn : forall {motive : Lean.Level -> Sort.{u}} (t : Lean.Level), (forall (t : Lean.Level), (Lean.Level.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : Lean.Level -> Sort.{u}} (t : Lean.Level) (F_1 : forall (t : Lean.Level), (Lean.Level.below.{u} motive t) -> (motive t)) => (Lean.Level.brecOn.go.{u} motive t F_1).1
