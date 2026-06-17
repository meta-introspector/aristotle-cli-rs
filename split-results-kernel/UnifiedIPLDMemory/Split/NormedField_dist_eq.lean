import Split.Norm_norm
import Split.Real
import Split.Ring_toNeg
import Split.AddMonoid_toAddSemigroup
import Split.NormedField_toField
import Split.NormedField_toNorm
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Field_toCommRing
import Split.NormedField
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.NormedField_toMetricSpace
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Semiring_toNonUnitalSemiring
import Split.MetricSpace_toPseudoMetricSpace
import Split.AddCommMonoid_toAddMonoid
import Split.Dist_dist
import Split.PseudoMetricSpace_toDist
import Split.CommRing_toRing
import Split.Ring_toSemiring
import Split.Eq
import Split.Neg_neg

-- NormedField.dist_eq from environment
-- theorem NormedField.dist_eq : forall {α : Type.{u_5}} [self : NormedField.{u_5} α] (x : α) (y : α), Eq.{1} Real (Dist.dist.{u_5} α (PseudoMetricSpace.toDist.{u_5} α (MetricSpace.toPseudoMetricSpace.{u_5} α (NormedField.toMetricSpace.{u_5} α self))) x y) (Norm.norm.{u_5} α (NormedField.toNorm.{u_5} α self) (HAdd.hAdd.{u_5, u_5, u_5} α α α (instHAdd.{u_5} α (AddSemigroup.toAdd.{u_5} α (AddMonoid.toAddSemigroup.{u_5} α (AddCommMonoid.toAddMonoid.{u_5} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (CommRing.toRing.{u_5} α (Field.toCommRing.{u_5} α (NormedField.toField.{u_5} α self))))))))))) (Neg.neg.{u_5} α (Ring.toNeg.{u_5} α (CommRing.toRing.{u_5} α (Field.toCommRing.{u_5} α (NormedField.toField.{u_5} α self)))) x) y))

-- Stub: this file represents the declaration `NormedField.dist_eq`.
-- In a full split, the body would be extracted from the environment.
