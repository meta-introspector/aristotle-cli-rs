import Split.Semiring_toNatCast
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.HSub_hSub
import Split.IntCast_intCast
import Split.IntCast
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.autoParam
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.Neg
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.Semiring
import Split.Semiring_toNonUnitalSemiring
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Ring
import Split.Neg_neg
import Split.Sub

-- Ring.mk from environment
-- constructor Ring.mk : forall {R : Type.{u}} [toSemiring : Semiring.{u} R] [toNeg : Neg.{u} R] [toSub : Sub.{u} R], (autoParam.{0} (forall (a : R) (b : R), Eq.{succ u} R (HSub.hSub.{u, u, u} R R R (instHSub.{u} R toSub) a b) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring))))))) a (Neg.neg.{u} R toNeg b))) SubNegMonoid.sub_eq_add_neg._autoParam) -> (forall (zsmul : Int -> R -> R), (autoParam.{0} (forall (a : R), Eq.{succ u} R (zsmul (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring)))))))) SubNegMonoid.zsmul_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : R), Eq.{succ u} R (zsmul (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring))))))) (zsmul (Nat.cast.{0} Int instNatCastInt n) a) a)) SubNegMonoid.zsmul_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : R), Eq.{succ u} R (zsmul (Int.negSucc n) a) (Neg.neg.{u} R toNeg (zsmul (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) SubNegMonoid.zsmul_neg'._autoParam) -> (forall (a : R), Eq.{succ u} R (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring))))))) (Neg.neg.{u} R toNeg a) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring)))))))) -> (forall [toIntCast : IntCast.{u} R], (autoParam.{0} (forall (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R toIntCast (Nat.cast.{0} Int instNatCastInt n)) (Nat.cast.{u} R (Semiring.toNatCast.{u} R toSemiring) n)) AddGroupWithOne.intCast_ofNat._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R toIntCast (Int.negSucc n)) (Neg.neg.{u} R toNeg (Nat.cast.{u} R (Semiring.toNatCast.{u} R toSemiring) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))) AddGroupWithOne.intCast_negSucc._autoParam) -> (Ring.{u} R)))

-- Stub: this file represents the declaration `Ring.mk`.
-- In a full split, the body would be extracted from the environment.
