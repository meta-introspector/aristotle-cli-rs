import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.SubNegMonoid
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

-- SubtractionMonoid.mk from environment
-- constructor SubtractionMonoid.mk : forall {G : Type.{u}} [toSubNegMonoid : SubNegMonoid.{u} G], (forall (x : G), Eq.{succ u} G (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G toSubNegMonoid) (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G toSubNegMonoid) x)) x) -> (forall (a : G) (b : G), Eq.{succ u} G (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G toSubNegMonoid) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G toSubNegMonoid)))) a b)) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G toSubNegMonoid)))) (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G toSubNegMonoid) b) (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G toSubNegMonoid) a))) -> (forall (a : G) (b : G), (Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G toSubNegMonoid)))) a b) (OfNat.ofNat.{u} G 0 (Zero.toOfNat0.{u} G (AddMonoid.toZero.{u} G (SubNegMonoid.toAddMonoid.{u} G toSubNegMonoid))))) -> (Eq.{succ u} G (Neg.neg.{u} G (SubNegMonoid.toNeg.{u} G toSubNegMonoid) a) b)) -> (SubtractionMonoid.{u} G)

-- Stub: this file represents the declaration `SubtractionMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
