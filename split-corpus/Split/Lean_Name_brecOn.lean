import Mathlib

set_option pp.all true
-- spec: Lean.Name.brecOn : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (forall (t : Lean.Name), (Lean.Name.below.{u} motive t) -> (motive t)) -> (motive t)
def Lean.Name.brecOn : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (forall (t : Lean.Name), (Lean.Name.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : Lean.Name -> Sort.{u}} (t : Lean.Name) (F_1 : forall (t : Lean.Name), (Lean.Name.below.{u} motive t) -> (motive t)) => (Lean.Name.brecOn.go.{u} motive t F_1).1
