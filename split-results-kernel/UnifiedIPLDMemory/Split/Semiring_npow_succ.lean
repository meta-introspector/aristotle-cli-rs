import Split.HMul_hMul
import Split.Semiring_npow
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Semiring
import Split.Semiring_toNonUnitalSemiring
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Semiring.npow_succ from environment
-- theorem Semiring.npow_succ : forall {α : Type.{u}} [self : Semiring.{u} α] (n : Nat) (x : α), Eq.{succ u} α (Semiring.npow.{u} α self (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α self)))) (Semiring.npow.{u} α self n x) x)

-- Stub: this file represents the declaration `Semiring.npow_succ`.
-- In a full split, the body would be extracted from the environment.
