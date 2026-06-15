import Split.Except_ok
import Split.Except_error
import Split.Except
import Split.Except_rec

-- Except.casesOn from environment
-- def Except.casesOn : forall {ε : Type.{u}} {α : Type.{v}} {motive : (Except.{u, v} ε α) -> Sort.{u_1}} (t : Except.{u, v} ε α), (forall (a._@._internal._hyg.0 : ε), motive (Except.error.{u, v} ε α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (Except.ok.{u, v} ε α a._@._internal._hyg.0)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Except.casesOn`.
-- In a full split, the body would be extracted from the environment.
