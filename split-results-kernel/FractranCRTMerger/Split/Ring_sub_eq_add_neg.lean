import Split.Ring_toSub
import Split.Ring_toNeg
import Split.AddMonoid_toAddSemigroup
import Split.HSub_hSub
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Semiring_toNonUnitalSemiring
import Split.AddCommMonoid_toAddMonoid
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.Neg_neg

-- Ring.sub_eq_add_neg from environment
-- theorem Ring.sub_eq_add_neg : forall {R : Type.{u}} [self : Ring.{u} R] (a : R) (b : R), Eq.{succ u} R (HSub.hSub.{u, u, u} R R R (instHSub.{u} R (Ring.toSub.{u} R self)) a b) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (Ring.toSemiring.{u} R self)))))))) a (Neg.neg.{u} R (Ring.toNeg.{u} R self) b))

-- Stub: this file represents the declaration `Ring.sub_eq_add_neg`.
-- In a full split, the body would be extracted from the environment.
