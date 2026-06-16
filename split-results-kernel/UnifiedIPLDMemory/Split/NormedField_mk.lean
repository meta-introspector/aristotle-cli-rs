import Split.Norm_norm
import Split.Real
import Split.HMul_hMul
import Split.Ring_toNeg
import Split.AddMonoid_toAddSemigroup
import Split.Norm
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Field_toCommRing
import Split.NormedField
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
import Split.CommRing_toRing
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Neg_neg
import Split.instHMul

-- NormedField.mk from environment
-- constructor NormedField.mk : forall {α : Type.{u_5}} [toNorm : Norm.{u_5} α] [toField : Field.{u_5} α] [toMetricSpace : MetricSpace.{u_5} α], (forall (x : α) (y : α), Eq.{1} Real (Dist.dist.{u_5} α (PseudoMetricSpace.toDist.{u_5} α (MetricSpace.toPseudoMetricSpace.{u_5} α toMetricSpace)) x y) (Norm.norm.{u_5} α toNorm (HAdd.hAdd.{u_5, u_5, u_5} α α α (instHAdd.{u_5} α (AddSemigroup.toAdd.{u_5} α (AddMonoid.toAddSemigroup.{u_5} α (AddCommMonoid.toAddMonoid.{u_5} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (CommRing.toRing.{u_5} α (Field.toCommRing.{u_5} α toField)))))))))) (Neg.neg.{u_5} α (Ring.toNeg.{u_5} α (CommRing.toRing.{u_5} α (Field.toCommRing.{u_5} α toField))) x) y))) -> (forall (a : α) (b : α), Eq.{1} Real (Norm.norm.{u_5} α toNorm (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocSemiring.toMul.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (CommRing.toRing.{u_5} α (Field.toCommRing.{u_5} α toField))))))) a b)) (HMul.hMul.{0, 0, 0} Real Real Real (instHMul.{0} Real Real.instMul) (Norm.norm.{u_5} α toNorm a) (Norm.norm.{u_5} α toNorm b))) -> (NormedField.{u_5} α)

-- Stub: this file represents the declaration `NormedField.mk`.
-- In a full split, the body would be extracted from the environment.
