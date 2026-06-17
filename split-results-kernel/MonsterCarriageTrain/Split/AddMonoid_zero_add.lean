import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddMonoid
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- AddMonoid.zero_add from environment
-- theorem AddMonoid.zero_add : forall {M : Type.{u}} [self : AddMonoid.{u} M] (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M (AddMonoid.toAddSemigroup.{u} M self))) (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M (AddMonoid.toZero.{u} M self))) a) a

-- Stub: this file represents the declaration `AddMonoid.zero_add`.
-- In a full split, the body would be extracted from the environment.
