import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.SubtractionMonoid_toSubNegMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.SubNegMonoid_toNeg
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- SubtractionMonoid.neg_eq_of_add from environment
-- theorem SubtractionMonoid.neg_eq_of_add : forall {G : Type.{u}} [self : SubtractionMonoid.{u} G] (a : G) (b : G), (Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self))))) a b) (OfNat.ofNat.{u} G 0 (Zero.toOfNat0.{u} G (AddMonoid.toZero.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)))))) -> (Eq.{succ u} G (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G self)) a) b)

-- Stub: this file represents the declaration `SubtractionMonoid.neg_eq_of_add`.
-- In a full split, the body would be extracted from the environment.
