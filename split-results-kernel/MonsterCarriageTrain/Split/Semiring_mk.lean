import Split.One
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NatCast
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.autoParam
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.NonUnitalSemiring
import Split.Nat
import Split.Semiring
import Split.One_toOfNat1
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Semiring.mk from environment
-- constructor Semiring.mk : forall {α : Type.{u}} [toNonUnitalSemiring : NonUnitalSemiring.{u} α] [toOne : One.{u} α], (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring))) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne)) a) a) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring))) a (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne))) a) -> (forall [toNatCast : NatCast.{u} α], (autoParam.{0} (Eq.{succ u} α (NatCast.natCast.{u} α toNatCast (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring))))))) AddMonoidWithOne.natCast_zero._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u} α (NatCast.natCast.{u} α toNatCast (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring)))))) (NatCast.natCast.{u} α toNatCast n) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne)))) AddMonoidWithOne.natCast_succ._autoParam) -> (forall (npow : Nat -> α -> α), (autoParam.{0} (forall (x : α), Eq.{succ u} α (npow (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne))) Monoid.npow_zero._autoParam) -> (autoParam.{0} (forall (n : Nat) (x : α), Eq.{succ u} α (npow (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring))) (npow n x) x)) Monoid.npow_succ._autoParam) -> (Semiring.{u} α)))

-- Stub: this file represents the declaration `Semiring.mk`.
-- In a full split, the body would be extracted from the environment.
