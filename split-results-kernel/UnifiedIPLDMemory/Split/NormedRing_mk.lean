import Split.Norm_norm
import Split.Real_instLE
import Split.Real
import Split.HMul_hMul
import Split.Ring_toNeg
import Split.AddMonoid_toAddSemigroup
import Split.Norm
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.LE_le
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.MetricSpace
import Split.HAdd_hAdd
import Split.Real_instMul
import Split.Semiring_toNonUnitalSemiring
import Split.MetricSpace_toPseudoMetricSpace
import Split.AddCommMonoid_toAddMonoid
import Split.Dist_dist
import Split.PseudoMetricSpace_toDist
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.NormedRing
import Split.Neg_neg
import Split.instHMul

-- NormedRing.mk from environment
-- constructor NormedRing.mk : forall {α : Type.{u_5}} [toNorm : Norm.{u_5} α] [toRing : Ring.{u_5} α] [toMetricSpace : MetricSpace.{u_5} α], (forall (x : α) (y : α), Eq.{1} Real (Dist.dist.{u_5} α (PseudoMetricSpace.toDist.{u_5} α (MetricSpace.toPseudoMetricSpace.{u_5} α toMetricSpace)) x y) (Norm.norm.{u_5} α toNorm (HAdd.hAdd.{u_5, u_5, u_5} α α α (instHAdd.{u_5} α (AddSemigroup.toAdd.{u_5} α (AddMonoid.toAddSemigroup.{u_5} α (AddCommMonoid.toAddMonoid.{u_5} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α toRing)))))))) (Neg.neg.{u_5} α (Ring.toNeg.{u_5} α toRing) x) y))) -> (forall (a : α) (b : α), LE.le.{0} Real Real.instLE (Norm.norm.{u_5} α toNorm (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocSemiring.toMul.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α toRing))))) a b)) (HMul.hMul.{0, 0, 0} Real Real Real (instHMul.{0} Real Real.instMul) (Norm.norm.{u_5} α toNorm a) (Norm.norm.{u_5} α toNorm b))) -> (NormedRing.{u_5} α)

-- Stub: this file represents the declaration `NormedRing.mk`.
-- In a full split, the body would be extracted from the environment.
