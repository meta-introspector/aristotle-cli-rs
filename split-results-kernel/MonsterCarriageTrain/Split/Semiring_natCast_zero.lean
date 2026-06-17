import Split.Semiring_toNatCast
import Split.AddMonoid_toZero
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Nat
import Split.Semiring
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq

-- Semiring.natCast_zero from environment
-- theorem Semiring.natCast_zero : forall {α : Type.{u}} [self : Semiring.{u} α], Eq.{succ u} α (NatCast.natCast.{u} α (Semiring.toNatCast.{u} α self) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α self)))))))

-- Stub: this file represents the declaration `Semiring.natCast_zero`.
-- In a full split, the body would be extracted from the environment.
