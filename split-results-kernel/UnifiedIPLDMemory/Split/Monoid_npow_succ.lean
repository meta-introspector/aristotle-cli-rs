import Split.Monoid
import Split.Monoid_npow
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Monoid_toSemigroup
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Monoid.npow_succ from environment
-- theorem Monoid.npow_succ : forall {M : Type.{u}} [self : Monoid.{u} M] (n : Nat) (x : M), Eq.{succ u} M (Monoid.npow.{u} M self (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x) (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M (Monoid.toSemigroup.{u} M self))) (Monoid.npow.{u} M self n x) x)

-- Stub: this file represents the declaration `Monoid.npow_succ`.
-- In a full split, the body would be extracted from the environment.
