import Split.And
import Split.And_intro

-- And.rec from environment
-- recursor And.rec : forall {a : Prop} {b : Prop} {motive : (And a b) -> Sort.{u}}, (forall (left : a) (right : b), motive (And.intro a b left right)) -> (forall (t : And a b), motive t)

-- Stub: this file represents the declaration `And.rec`.
-- In a full split, the body would be extracted from the environment.
