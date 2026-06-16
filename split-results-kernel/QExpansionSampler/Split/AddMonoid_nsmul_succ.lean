import Split.AddMonoid_toAddSemigroup
import Split.instOfNatNat
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.AddMonoid
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.AddMonoid_nsmul

-- AddMonoid.nsmul_succ from environment
-- theorem AddMonoid.nsmul_succ : forall {M : Type.{u}} [self : AddMonoid.{u} M] (n : Nat) (x : M), Eq.{succ u} M (AddMonoid.nsmul.{u} M self (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x) (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M (AddMonoid.toAddSemigroup.{u} M self))) (AddMonoid.nsmul.{u} M self n x) x)

-- Stub: this file represents the declaration `AddMonoid.nsmul_succ`.
-- In a full split, the body would be extracted from the environment.
