import Mathlib

set_option pp.all true
-- spec: Except.casesOn : forall {ε : Type.{u}} {α : Type.{v}} {motive : (Except.{u, v} ε α) -> Sort.{u_1}} (t : Except.{u, v} ε α), (forall (a._@._internal._hyg.0 : ε), motive (Except.error.{u, v} ε α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (Except.ok.{u, v} ε α a._@._internal._hyg.0)) -> (motive t)
def Except.casesOn : forall {ε : Type.{u}} {α : Type.{v}} {motive : (Except.{u, v} ε α) -> Sort.{u_1}} (t : Except.{u, v} ε α), (forall (a._@._internal._hyg.0 : ε), motive (Except.error.{u, v} ε α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (Except.ok.{u, v} ε α a._@._internal._hyg.0)) -> (motive t) :=
  fun {ε : Type.{u}} {α : Type.{v}} {motive : (Except.{u, v} ε α) -> Sort.{u_1}} (t : Except.{u, v} ε α) (error : forall (a._@._internal._hyg.0 : ε), motive (Except.error.{u, v} ε α a._@._internal._hyg.0)) (ok : forall (a._@._internal._hyg.0 : α), motive (Except.ok.{u, v} ε α a._@._internal._hyg.0)) => Except.rec.{u_1, u, v} ε α motive (fun (a._@._internal._hyg.0 : ε) => error a._@._internal._hyg.0) (fun (a._@._internal._hyg.0 : α) => ok a._@._internal._hyg.0) t
