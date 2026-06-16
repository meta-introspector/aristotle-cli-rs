import Split.Or_rec
import Split.Or_inl
import Split.Or
import Split.Or_inr

-- Or.casesOn from environment
-- def Or.casesOn : forall {a : Prop} {b : Prop} {motive : (Or a b) -> Prop} (t : Or a b), (forall (h : a), motive (Or.inl a b h)) -> (forall (h : b), motive (Or.inr a b h)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Or.casesOn`.
-- In a full split, the body would be extracted from the environment.
