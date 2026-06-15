import Split.Decidable_isTrue
import Split.Decidable
import Split.Decidable_rec
import Split.Decidable_isFalse
import Split.Not

-- Decidable.casesOn from environment
-- def Decidable.casesOn : forall {p : Prop} {motive : (Decidable p) -> Sort.{u}} (t : Decidable p), (forall (h : Not p), motive (Decidable.isFalse p h)) -> (forall (h : p), motive (Decidable.isTrue p h)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Decidable.casesOn`.
-- In a full split, the body would be extracted from the environment.
