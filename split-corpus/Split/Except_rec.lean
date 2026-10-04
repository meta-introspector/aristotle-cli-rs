import Mathlib

-- spec: recursor Except.rec : forall {ε : Type.{u}} {α : Type.{v}} {motive : (Except.{u, v} ε α) -> Sort.{u_1}}, (forall (a._@._internal._hyg.0 : ε), motive (Except.error.{u, v} ε α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (Except.ok.{u, v} ε α a._@._internal._hyg.0)) -> (forall (t : Except.{u, v} ε α), motive t)
