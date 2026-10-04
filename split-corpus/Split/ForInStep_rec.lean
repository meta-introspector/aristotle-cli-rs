import Mathlib

-- spec: recursor ForInStep.rec : forall {α : Type.{u}} {motive : (ForInStep.{u} α) -> Sort.{u_1}}, (forall (a._@._internal._hyg.0 : α), motive (ForInStep.done.{u} α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (ForInStep.yield.{u} α a._@._internal._hyg.0)) -> (forall (t : ForInStep.{u} α), motive t)
