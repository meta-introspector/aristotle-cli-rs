import Mathlib

set_option pp.all true
-- spec: List.casesOn : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α), (motive (List.nil.{u} α)) -> (forall (head : α) (tail : List.{u} α), motive (List.cons.{u} α head tail)) -> (motive t)
def List.casesOn : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α), (motive (List.nil.{u} α)) -> (forall (head : α) (tail : List.{u} α), motive (List.cons.{u} α head tail)) -> (motive t) :=
  fun {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α) (nil : motive (List.nil.{u} α)) (cons : forall (head : α) (tail : List.{u} α), motive (List.cons.{u} α head tail)) => List.rec.{u_1, u} α motive nil (fun (head : α) (tail : List.{u} α) (tail_ih : motive tail) => cons head tail) t
