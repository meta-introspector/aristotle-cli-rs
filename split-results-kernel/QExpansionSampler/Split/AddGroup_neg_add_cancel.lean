import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- AddGroup.neg_add_cancel from environment
-- theorem AddGroup.neg_add_cancel : forall {A : Type.{u}} [self : AddGroup.{u} A] (a : A), Eq.{succ u} A (HAdd.hAdd.{u, u, u} A A A (instHAdd.{u} A (AddSemigroup.toAdd.{u} A (AddMonoid.toAddSemigroup.{u} A (SubNegMonoid.toAddMonoid.{u} A (AddGroup.toSubNegMonoid.{u} A self))))) (Neg.neg.{u} A (SubNegMonoid.toNeg.{u} A (AddGroup.toSubNegMonoid.{u} A self)) a) a) (OfNat.ofNat.{u} A 0 (Zero.toOfNat0.{u} A (AddMonoid.toZero.{u} A (SubNegMonoid.toAddMonoid.{u} A (AddGroup.toSubNegMonoid.{u} A self)))))

-- Stub: this file represents the declaration `AddGroup.neg_add_cancel`.
-- In a full split, the body would be extracted from the environment.
