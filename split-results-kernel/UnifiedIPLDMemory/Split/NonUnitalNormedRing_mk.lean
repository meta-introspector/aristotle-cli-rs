import Split.Norm_norm
import Split.Real_instLE
import Split.Real
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.AddCommGroup_toAddGroup
import Split.NonUnitalRing_toNonUnitalNonAssocRing
import Split.Norm
import Split.NonUnitalNormedRing
import Split.LE_le
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.MetricSpace
import Split.HAdd_hAdd
import Split.Real_instMul
import Split.SubNegMonoid_toNeg
import Split.MetricSpace_toPseudoMetricSpace
import Split.Dist_dist
import Split.PseudoMetricSpace_toDist
import Split.NonUnitalRing
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg
import Split.instHMul

-- NonUnitalNormedRing.mk from environment
-- constructor NonUnitalNormedRing.mk : forall {α : Type.{u_5}} [toNorm : Norm.{u_5} α] [toNonUnitalRing : NonUnitalRing.{u_5} α] [toMetricSpace : MetricSpace.{u_5} α], (forall (x : α) (y : α), Eq.{1} Real (Dist.dist.{u_5} α (PseudoMetricSpace.toDist.{u_5} α (MetricSpace.toPseudoMetricSpace.{u_5} α toMetricSpace)) x y) (Norm.norm.{u_5} α toNorm (HAdd.hAdd.{u_5, u_5, u_5} α α α (instHAdd.{u_5} α (AddSemigroup.toAdd.{u_5} α (AddMonoid.toAddSemigroup.{u_5} α (SubNegMonoid.toAddMonoid.{u_5} α (AddGroup.toSubNegMonoid.{u_5} α (AddCommGroup.toAddGroup.{u_5} α (NonUnitalNonAssocRing.toAddCommGroup.{u_5} α (NonUnitalRing.toNonUnitalNonAssocRing.{u_5} α toNonUnitalRing)))))))) (Neg.neg.{u_5} α (SubNegMonoid.toNeg.{u_5} α (AddGroup.toSubNegMonoid.{u_5} α (AddCommGroup.toAddGroup.{u_5} α (NonUnitalNonAssocRing.toAddCommGroup.{u_5} α (NonUnitalRing.toNonUnitalNonAssocRing.{u_5} α toNonUnitalRing))))) x) y))) -> (forall (a : α) (b : α), LE.le.{0} Real Real.instLE (Norm.norm.{u_5} α toNorm (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocRing.toMul.{u_5} α (NonUnitalRing.toNonUnitalNonAssocRing.{u_5} α toNonUnitalRing))) a b)) (HMul.hMul.{0, 0, 0} Real Real Real (instHMul.{0} Real Real.instMul) (Norm.norm.{u_5} α toNorm a) (Norm.norm.{u_5} α toNorm b))) -> (NonUnitalNormedRing.{u_5} α)

-- Stub: this file represents the declaration `NonUnitalNormedRing.mk`.
-- In a full split, the body would be extracted from the environment.
