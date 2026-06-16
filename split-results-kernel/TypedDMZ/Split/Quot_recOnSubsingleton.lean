import Split.Quot_rec
import Split.Subsingleton
import Split.Quot
import Split.Quot_mk

-- Quot.recOnSubsingleton from environment
-- def Quot.recOnSubsingleton : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : (Quot.{u} α r) -> Sort.{v}} [h : forall (a : α), Subsingleton.{v} (motive (Quot.mk.{u} α r a))] (q : Quot.{u} α r), (forall (a : α), motive (Quot.mk.{u} α r a)) -> (motive q)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quot.recOnSubsingleton`.
-- In a full split, the body would be extracted from the environment.
