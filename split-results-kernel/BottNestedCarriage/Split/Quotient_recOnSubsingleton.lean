import Split.Quot_recOnSubsingleton
import Split.Setoid
import Split.Quotient_mk
import Split.Quotient
import Split.Subsingleton
import Split.Setoid_r

-- Quotient.recOnSubsingleton from environment
-- def Quotient.recOnSubsingleton : forall {α : Sort.{u}} {s : Setoid.{u} α} {motive : (Quotient.{u} α s) -> Sort.{v}} [h : forall (a : α), Subsingleton.{v} (motive (Quotient.mk.{u} α s a))] (q : Quotient.{u} α s), (forall (a : α), motive (Quotient.mk.{u} α s a)) -> (motive q)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quotient.recOnSubsingleton`.
-- In a full split, the body would be extracted from the environment.
