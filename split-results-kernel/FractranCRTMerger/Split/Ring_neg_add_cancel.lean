import Split.Ring_toNeg
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.Neg_neg

-- Ring.neg_add_cancel from environment
-- theorem Ring.neg_add_cancel : forall {R : Type.{u}} [self : Ring.{u} R] (a : R), Eq.{succ u} R (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (Ring.toSemiring.{u} R self)))))))) (Neg.neg.{u} R (Ring.toNeg.{u} R self) a) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (Ring.toSemiring.{u} R self))))))))

-- Stub: this file represents the declaration `Ring.neg_add_cancel`.
-- In a full split, the body would be extracted from the environment.
