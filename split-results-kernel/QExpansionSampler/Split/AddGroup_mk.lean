import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.SubNegMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- AddGroup.mk from environment
-- constructor AddGroup.mk : forall {A : Type.{u}} [toSubNegMonoid : SubNegMonoid.{u} A], (forall (a : A), Eq.{succ u} A (HAdd.hAdd.{u, u, u} A A A (instHAdd.{u} A (AddSemigroup.toAdd.{u} A (AddMonoid.toAddSemigroup.{u} A (SubNegMonoid.toAddMonoid.{u} A toSubNegMonoid)))) (Neg.neg.{u} A (SubNegMonoid.toNeg.{u} A toSubNegMonoid) a) a) (OfNat.ofNat.{u} A 0 (Zero.toOfNat0.{u} A (AddMonoid.toZero.{u} A (SubNegMonoid.toAddMonoid.{u} A toSubNegMonoid))))) -> (AddGroup.{u} A)

-- Stub: this file represents the declaration `AddGroup.mk`.
-- In a full split, the body would be extracted from the environment.
