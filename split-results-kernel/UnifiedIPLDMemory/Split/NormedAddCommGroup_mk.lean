import Split.Norm_norm
import Split.Real
import Split.AddMonoid_toAddSemigroup
import Split.AddCommGroup_toAddGroup
import Split.AddCommGroup
import Split.Norm
import Split.autoParam
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.MetricSpace
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.MetricSpace_toPseudoMetricSpace
import Split.Dist_dist
import Split.PseudoMetricSpace_toDist
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg
import Split.NormedAddCommGroup

-- NormedAddCommGroup.mk from environment
-- constructor NormedAddCommGroup.mk : forall {E : Type.{u_8}} [toNorm : Norm.{u_8} E] [toAddCommGroup : AddCommGroup.{u_8} E] [toMetricSpace : MetricSpace.{u_8} E], (autoParam.{0} (forall (x : E) (y : E), Eq.{1} Real (Dist.dist.{u_8} E (PseudoMetricSpace.toDist.{u_8} E (MetricSpace.toPseudoMetricSpace.{u_8} E toMetricSpace)) x y) (Norm.norm.{u_8} E toNorm (HAdd.hAdd.{u_8, u_8, u_8} E E E (instHAdd.{u_8} E (AddSemigroup.toAdd.{u_8} E (AddMonoid.toAddSemigroup.{u_8} E (SubNegMonoid.toAddMonoid.{u_8} E (AddGroup.toSubNegMonoid.{u_8} E (AddCommGroup.toAddGroup.{u_8} E toAddCommGroup)))))) (Neg.neg.{u_8} E (SubNegMonoid.toNeg.{u_8} E (AddGroup.toSubNegMonoid.{u_8} E (AddCommGroup.toAddGroup.{u_8} E toAddCommGroup))) x) y))) NormedAddCommGroup.dist_eq._autoParam) -> (NormedAddCommGroup.{u_8} E)

-- Stub: this file represents the declaration `NormedAddCommGroup.mk`.
-- In a full split, the body would be extracted from the environment.
