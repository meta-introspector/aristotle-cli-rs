import Mathlib

set_option pp.all true
-- spec: List.brecOn : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α), (forall (t : List.{u} α), (List.below.{u_1, u} α motive t) -> (motive t)) -> (motive t)
def List.brecOn : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α), (forall (t : List.{u} α), (List.below.{u_1, u} α motive t) -> (motive t)) -> (motive t) :=
  fun {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α) (F_1 : forall (t : List.{u} α), (List.below.{u_1, u} α motive t) -> (motive t)) => (List.brecOn.go.{u_1, u} α motive t F_1).1
