import Split.One
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NatCast
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.autoParam
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.NonAssocSemiring
import Split.HAdd_hAdd
import Split.Nat
import Split.One_toOfNat1
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.NonUnitalNonAssocSemiring
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- NonAssocSemiring.mk from environment
-- constructor NonAssocSemiring.mk : forall {α : Type.{u}} [toNonUnitalNonAssocSemiring : NonUnitalNonAssocSemiring.{u} α] [toOne : One.{u} α], (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne)) a) a) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) a (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne))) a) -> (forall [toNatCast : NatCast.{u} α], (autoParam.{0} (Eq.{succ u} α (NatCast.natCast.{u} α toNatCast (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α toNonUnitalNonAssocSemiring)))))) AddMonoidWithOne.natCast_zero._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u} α (NatCast.natCast.{u} α toNatCast (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α toNonUnitalNonAssocSemiring))))) (NatCast.natCast.{u} α toNatCast n) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α toOne)))) AddMonoidWithOne.natCast_succ._autoParam) -> (NonAssocSemiring.{u} α))

-- Stub: this file represents the declaration `NonAssocSemiring.mk`.
-- In a full split, the body would be extracted from the environment.
