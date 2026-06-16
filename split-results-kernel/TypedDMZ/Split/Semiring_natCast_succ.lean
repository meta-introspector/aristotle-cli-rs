import Split.Semiring_toNatCast
import Split.Semiring_toOne
import Split.AddMonoid_toAddSemigroup
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Semiring
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.instAddNat
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq

-- Semiring.natCast_succ from environment
-- theorem Semiring.natCast_succ : forall {α : Type.{u}} [self : Semiring.{u} α] (n : Nat), Eq.{succ u} α (NatCast.natCast.{u} α (Semiring.toNatCast.{u} α self) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α self))))))) (NatCast.natCast.{u} α (Semiring.toNatCast.{u} α self) n) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (Semiring.toOne.{u} α self))))

-- Stub: this file represents the declaration `Semiring.natCast_succ`.
-- In a full split, the body would be extracted from the environment.
