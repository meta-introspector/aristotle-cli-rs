import Mathlib

set_option pp.all true
-- spec: Array.casesOn : forall {α : Type.{u}} {motive : (Array.{u} α) -> Sort.{u_1}} (t : Array.{u} α), (forall (toList : List.{u} α), motive (Array.mk.{u} α toList)) -> (motive t)
def Array.casesOn : forall {α : Type.{u}} {motive : (Array.{u} α) -> Sort.{u_1}} (t : Array.{u} α), (forall (toList : List.{u} α), motive (Array.mk.{u} α toList)) -> (motive t) :=
  fun {α : Type.{u}} {motive : (Array.{u} α) -> Sort.{u_1}} (t : Array.{u} α) (mk : forall (toList : List.{u} α), motive (Array.mk.{u} α toList)) => Array.rec.{u_1, u} α motive (fun (toList : List.{u} α) => mk toList) t
