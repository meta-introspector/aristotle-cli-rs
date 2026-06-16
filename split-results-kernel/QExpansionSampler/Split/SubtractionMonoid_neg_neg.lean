import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubtractionMonoid
import Split.SubNegMonoid_toNeg
import Split.Eq
import Split.Neg_neg

-- SubtractionMonoid.neg_neg from environment
-- theorem SubtractionMonoid.neg_neg : forall {G : Type.{u}} [self : SubtractionMonoid.{u} G] (x : G), Eq.{succ u} G (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)) (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)) x)) x

-- Stub: this file represents the declaration `SubtractionMonoid.neg_neg`.
-- In a full split, the body would be extracted from the environment.
