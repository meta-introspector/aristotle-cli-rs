import Split.AddMonoid_toAddSemigroup
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Int
import Split.Nat_cast
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Semiring_toNonUnitalSemiring
import Split.AddCommMonoid_toAddMonoid
import Split.instNatCastInt
import Split.Ring_toSemiring
import Split.Nat_succ
import Split.Eq
import Split.Ring_zsmul
import Split.Ring

-- Ring.zsmul_succ' from environment
-- theorem Ring.zsmul_succ' : forall {R : Type.{u}} [self : Ring.{u} R] (n : Nat) (a : R), Eq.{succ u} R (Ring.zsmul.{u} R self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (Ring.toSemiring.{u} R self)))))))) (Ring.zsmul.{u} R self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `Ring.zsmul_succ'`.
-- In a full split, the body would be extracted from the environment.
