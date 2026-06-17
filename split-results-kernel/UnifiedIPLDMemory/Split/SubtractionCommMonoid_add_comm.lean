import Split.AddMonoid_toAddSemigroup
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.SubNegMonoid_toAddMonoid
import Split.SubtractionCommMonoid
import Split.Eq

-- SubtractionCommMonoid.add_comm from environment
-- theorem SubtractionCommMonoid.add_comm : forall {G : Type.{u}} [self : SubtractionCommMonoid.{u} G] (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G (SubtractionCommMonoid.toSubtractionMonoid.{u} G self)))))) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (SubtractionMonoid.toSubNegMonoid.{u} G (SubtractionCommMonoid.toSubtractionMonoid.{u} G self)))))) b a)

-- Stub: this file represents the declaration `SubtractionCommMonoid.add_comm`.
-- In a full split, the body would be extracted from the environment.
