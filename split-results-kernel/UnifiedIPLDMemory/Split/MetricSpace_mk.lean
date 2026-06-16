import Split.Real
import Split.Real_instZero
import Split.PseudoMetricSpace
import Split.MetricSpace
import Split.Zero_toOfNat0
import Split.Dist_dist
import Split.PseudoMetricSpace_toDist
import Split.OfNat_ofNat
import Split.Eq

-- MetricSpace.mk from environment
-- constructor MetricSpace.mk : forall {α : Type.{u}} [toPseudoMetricSpace : PseudoMetricSpace.{u} α], (forall {x : α} {y : α}, (Eq.{1} Real (Dist.dist.{u} α (PseudoMetricSpace.toDist.{u} α toPseudoMetricSpace) x y) (OfNat.ofNat.{0} Real 0 (Zero.toOfNat0.{0} Real Real.instZero))) -> (Eq.{succ u} α x y)) -> (MetricSpace.{u} α)

-- Stub: this file represents the declaration `MetricSpace.mk`.
-- In a full split, the body would be extracted from the environment.
