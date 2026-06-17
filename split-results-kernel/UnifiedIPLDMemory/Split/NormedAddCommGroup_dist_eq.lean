import Split.Norm_norm
import Split.Real
import Split.AddMonoid_toAddSemigroup
import Split.NormedAddCommGroup_toMetricSpace
import Split.AddCommGroup_toAddGroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.NormedAddCommGroup_toNorm
import Split.SubNegMonoid_toNeg
import Split.NormedAddCommGroup_toAddCommGroup
import Split.MetricSpace_toPseudoMetricSpace
import Split.Dist_dist
import Split.PseudoMetricSpace_toDist
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg
import Split.NormedAddCommGroup

-- NormedAddCommGroup.dist_eq from environment
-- theorem NormedAddCommGroup.dist_eq : forall {E : Type.{u_8}} [self : NormedAddCommGroup.{u_8} E] (x : E) (y : E), Eq.{1} Real (Dist.dist.{u_8} E (PseudoMetricSpace.toDist.{u_8} E (MetricSpace.toPseudoMetricSpace.{u_8} E (NormedAddCommGroup.toMetricSpace.{u_8} E self))) x y) (Norm.norm.{u_8} E (NormedAddCommGroup.toNorm.{u_8} E self) (HAdd.hAdd.{u_8, u_8, u_8} E E E (instHAdd.{u_8} E (AddSemigroup.toAdd.{u_8} E (AddMonoid.toAddSemigroup.{u_8} E (SubNegMonoid.toAddMonoid.{u_8} E (AddGroup.toSubNegMonoid.{u_8} E (AddCommGroup.toAddGroup.{u_8} E (NormedAddCommGroup.toAddCommGroup.{u_8} E self))))))) (Neg.neg.{u_8} E (SubNegMonoid.toNeg.{u_8} E (AddGroup.toSubNegMonoid.{u_8} E (AddCommGroup.toAddGroup.{u_8} E (NormedAddCommGroup.toAddCommGroup.{u_8} E self)))) x) y))

-- Stub: this file represents the declaration `NormedAddCommGroup.dist_eq`.
-- In a full split, the body would be extracted from the environment.
