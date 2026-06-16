import Split.Decidable_isTrue
import Split.Decidable
import Split.Decidable_isFalse
import Split.Not

-- Decidable.rec from environment
-- recursor Decidable.rec : forall {p : Prop} {motive : (Decidable p) -> Sort.{u}}, (forall (h : Not p), motive (Decidable.isFalse p h)) -> (forall (h : p), motive (Decidable.isTrue p h)) -> (forall (t : Decidable p), motive t)

-- Stub: this file represents the declaration `Decidable.rec`.
-- In a full split, the body would be extracted from the environment.
