import Split.AddMonoid_toAddSemigroup
import Split.SubtractionMonoid_toSubNegMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.SubNegMonoid_toAddMonoid
import Split.SubtractionCommMonoid
import Split.Eq

-- SubtractionCommMonoid.mk from environment
-- constructor SubtractionCommMonoid.mk : forall {G : Type.{u}} [toSubtractionMonoid : SubtractionMonoid.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G toSubtractionMonoid))))) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G toSubtractionMonoid))))) b a)) -> (SubtractionCommMonoid.{u} G)

-- Stub: this file represents the declaration `SubtractionCommMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
