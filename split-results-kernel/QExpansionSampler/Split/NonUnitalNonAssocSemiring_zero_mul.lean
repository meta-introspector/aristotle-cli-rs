import Split.HMul_hMul
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.NonUnitalNonAssocSemiring
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocSemiring.zero_mul from environment
-- theorem NonUnitalNonAssocSemiring.zero_mul : forall {α : Type.{u}} [self : NonUnitalNonAssocSemiring.{u} α] (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α self)) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α self))))) a) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α self)))))

-- Stub: this file represents the declaration `NonUnitalNonAssocSemiring.zero_mul`.
-- In a full split, the body would be extracted from the environment.
