import Mathlib

-- spec: recursor Lean.RArray.rec : forall {α : Type.{u}} {motive : (Lean.RArray.{u} α) -> Sort.{u_1}}, (forall (a._@._internal._hyg.0 : α), motive (Lean.RArray.leaf.{u} α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : Nat) (a_1._@._internal._hyg.0 : Lean.RArray.{u} α) (a_2._@._internal._hyg.0 : Lean.RArray.{u} α), (motive a_1._@._internal._hyg.0) -> (motive a_2._@._internal._hyg.0) -> (motive (Lean.RArray.branch.{u} α a._@._internal._hyg.0 a_1._@._internal._hyg.0 a_2._@._internal._hyg.0))) -> (forall (t : Lean.RArray.{u} α), motive t)
