import Split.Or_inl
import Split.Or
import Split.Or_inr

-- Or.rec from environment
-- recursor Or.rec : forall {a : Prop} {b : Prop} {motive : (Or a b) -> Prop}, (forall (h : a), motive (Or.inl a b h)) -> (forall (h : b), motive (Or.inr a b h)) -> (forall (t : Or a b), motive t)

-- Stub: this file represents the declaration `Or.rec`.
-- In a full split, the body would be extracted from the environment.
