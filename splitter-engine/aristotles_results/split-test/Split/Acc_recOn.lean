import Split.Acc
import Split.Acc_rec
import Split.Acc_intro

-- Acc.recOn from environment
-- def Acc.recOn : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : forall (a._@._internal._hyg.0 : α), (Acc.{u} α r a._@._internal._hyg.0) -> Sort.{u_1}} {a._@._internal._hyg.0 : α} (t : Acc.{u} α r a._@._internal._hyg.0), (forall (x : α) (h : forall (y : α), (r y x) -> (Acc.{u} α r y)), (forall (y : α) (a._@._internal._hyg.0 : r y x), motive y (h y a._@._internal._hyg.0)) -> (motive x (Acc.intro.{u} α r x h))) -> (motive a._@._internal._hyg.0 t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Acc.recOn`.
-- In a full split, the body would be extracted from the environment.
