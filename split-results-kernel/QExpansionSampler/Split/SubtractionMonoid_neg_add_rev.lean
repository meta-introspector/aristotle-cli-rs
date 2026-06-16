import Split.AddMonoid_toAddSemigroup
import Split.SubtractionMonoid_toSubNegMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.SubNegMonoid_toNeg
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- SubtractionMonoid.neg_add_rev from environment
-- theorem SubtractionMonoid.neg_add_rev : forall {G : Type.{u}} [self : SubtractionMonoid.{u} G] (a : G) (b : G), Eq.{succ u} G (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self))))) a b)) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self))))) (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)) b) (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)) a))

-- Stub: this file represents the declaration `SubtractionMonoid.neg_add_rev`.
-- In a full split, the body would be extracted from the environment.
