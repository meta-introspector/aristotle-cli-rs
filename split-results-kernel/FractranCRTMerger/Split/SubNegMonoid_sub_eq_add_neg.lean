import Split.AddMonoid_toAddSemigroup
import Split.HSub_hSub
import Split.SubNegMonoid
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- SubNegMonoid.sub_eq_add_neg from environment
-- theorem SubNegMonoid.sub_eq_add_neg : forall {G : Type.{u}} [self : SubNegMonoid.{u} G] (a : G) (b : G), Eq.{succ u} G (HSub.hSub.{u, u, u} G G G (instHSub.{u} G (SubNegMonoid.toSub.{u} G self)) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G self)))) a (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G self) b))

-- Stub: this file represents the declaration `SubNegMonoid.sub_eq_add_neg`.
-- In a full split, the body would be extracted from the environment.
