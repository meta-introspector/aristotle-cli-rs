import Split.Except_ok
import Split.Except_error
import Split.Except

-- Except.rec from environment
-- recursor Except.rec : forall {ε : Type.{u}} {α : Type.{v}} {motive : (Except.{u, v} ε α) -> Sort.{u_1}}, (forall (a._@._internal._hyg.0 : ε), motive (Except.error.{u, v} ε α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : α), motive (Except.ok.{u, v} ε α a._@._internal._hyg.0)) -> (forall (t : Except.{u, v} ε α), motive t)

-- Stub: this file represents the declaration `Except.rec`.
-- In a full split, the body would be extracted from the environment.
