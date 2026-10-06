import Mathlib

set_option pp.all true
-- spec: ForInStep.casesOn : forall {α : Type.{u}} {motive : (ForInStep.{u} α) -> Sort.{u_1}} (t : ForInStep.{u} α), (forall (a._@._internal._hyg.0 : α), motive (ForInStep.done.{u} α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (ForInStep.yield.{u} α a._@._internal._hyg.0)) -> (motive t)
def ForInStep.casesOn : forall {α : Type.{u}} {motive : (ForInStep.{u} α) -> Sort.{u_1}} (t : ForInStep.{u} α), (forall (a._@._internal._hyg.0 : α), motive (ForInStep.done.{u} α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (ForInStep.yield.{u} α a._@._internal._hyg.0)) -> (motive t) :=
  fun {α : Type.{u}} {motive : (ForInStep.{u} α) -> Sort.{u_1}} (t : ForInStep.{u} α) (done : forall (a._@._internal._hyg.0 : α), motive (ForInStep.done.{u} α a._@._internal._hyg.0)) (yield : forall (a._@._internal._hyg.0 : α), motive (ForInStep.yield.{u} α a._@._internal._hyg.0)) => ForInStep.rec.{u_1, u} α motive (fun (a._@._internal._hyg.0 : α) => done a._@._internal._hyg.0) (fun (a._@._internal._hyg.0 : α) => yield a._@._internal._hyg.0) t
