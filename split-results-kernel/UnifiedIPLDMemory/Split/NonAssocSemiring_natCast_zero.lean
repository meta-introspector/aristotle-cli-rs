import Split.AddMonoid_toZero
import Split.instOfNatNat
import Split.NatCast_natCast
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.NonAssocSemiring
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.NonAssocSemiring_toNatCast
import Split.OfNat_ofNat
import Split.Eq

-- NonAssocSemiring.natCast_zero from environment
-- theorem NonAssocSemiring.natCast_zero : forall {α : Type.{u}} [self : NonAssocSemiring.{u} α], Eq.{succ u} α (NatCast.natCast.{u} α (NonAssocSemiring.toNatCast.{u} α self) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} α self))))))

-- Stub: this file represents the declaration `NonAssocSemiring.natCast_zero`.
-- In a full split, the body would be extracted from the environment.
