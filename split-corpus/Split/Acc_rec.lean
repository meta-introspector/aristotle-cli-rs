import Mathlib

-- spec: recursor Acc.rec : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : forall (a._@._internal._hyg.0 : α), (Acc.{u} α r a._@._internal._hyg.0) -> Sort.{u_1}}, (forall (x : α) (h : forall (y : α), (r y x) -> (Acc.{u} α r y)), (forall (y : α) (a._@._internal._hyg.0 : r y x), motive y (h y a._@._internal._hyg.0)) -> (motive x (Acc.intro.{u} α r x h))) -> (forall {a._@._internal._hyg.0 : α} (t : Acc.{u} α r a._@._internal._hyg.0), motive a._@._internal._hyg.0 t)
