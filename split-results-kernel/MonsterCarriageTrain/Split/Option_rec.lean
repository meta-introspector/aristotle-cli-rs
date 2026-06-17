import Split.Option_some
import Split.Option_none
import Split.Option

-- Option.rec from environment
-- recursor Option.rec : forall {α : Type.{u}} {motive : (Option.{u} α) -> Sort.{u_1}}, (motive (Option.none.{u} α)) -> (forall (val : α), motive (Option.some.{u} α val)) -> (forall (t : Option.{u} α), motive t)

-- Stub: this file represents the declaration `Option.rec`.
-- In a full split, the body would be extracted from the environment.
