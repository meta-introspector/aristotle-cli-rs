import Split.UniformSpace
import Split.Real_instLE
import Split.Real
import Split.iInf
import Split.Real_instZero
import Split.ENNReal_ofReal
import Split.Compl_compl
import Split.Filter_instInfSet
import Split.uniformity
import Split.setOf
import Split.Real_instLT
import Split.Membership_mem
import Split.Exists
import Split.Filter_sets
import Split.LE_le
import Split.autoParam
import Split.Set_instCompl
import Split.Prod_fst
import Split.Real_instAdd
import Split.GT_gt
import Split.instHAdd
import Split.PseudoMetricSpace
import Split.HAdd_hAdd
import Split.LT_lt
import Split.ENNReal
import Split.Filter_principal
import Split.Zero_toOfNat0
import Split.Bornology_cobounded
import Split.Dist_dist
import Split.Dist
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.Set_instMembership
import Split.Prod_snd
import Split.Bornology
import Split.Filter
import Split.Set

-- PseudoMetricSpace.mk from environment
-- constructor PseudoMetricSpace.mk : forall {α : Type.{u}} [toDist : Dist.{u} α], (forall (x : α), Eq.{1} Real (Dist.dist.{u} α toDist x x) (OfNat.ofNat.{0} Real 0 (Zero.toOfNat0.{0} Real Real.instZero))) -> (forall (x : α) (y : α), Eq.{1} Real (Dist.dist.{u} α toDist x y) (Dist.dist.{u} α toDist y x)) -> (forall (x : α) (y : α) (z : α), LE.le.{0} Real Real.instLE (Dist.dist.{u} α toDist x z) (HAdd.hAdd.{0, 0, 0} Real Real Real (instHAdd.{0} Real Real.instAdd) (Dist.dist.{u} α toDist x y) (Dist.dist.{u} α toDist y z))) -> (forall (edist : α -> α -> ENNReal), (autoParam.{0} (forall (x : α) (y : α), Eq.{1} ENNReal (edist x y) (ENNReal.ofReal (Dist.dist.{u} α toDist x y))) PseudoMetricSpace.edist_dist._autoParam) -> (forall (toUniformSpace : UniformSpace.{u} α), (autoParam.{0} (Eq.{succ u} (Filter.{u} (Prod.{u, u} α α)) (uniformity.{u} α toUniformSpace) (iInf.{u, 1} (Filter.{u} (Prod.{u, u} α α)) Real (Filter.instInfSet.{u} (Prod.{u, u} α α)) (fun (ε : Real) => iInf.{u, 0} (Filter.{u} (Prod.{u, u} α α)) (GT.gt.{0} Real Real.instLT ε (OfNat.ofNat.{0} Real 0 (Zero.toOfNat0.{0} Real Real.instZero))) (Filter.instInfSet.{u} (Prod.{u, u} α α)) (fun (h._@.Mathlib.Topology.MetricSpace.Pseudo.Defs.3940956446._hygCtx._hyg.144 : GT.gt.{0} Real Real.instLT ε (OfNat.ofNat.{0} Real 0 (Zero.toOfNat0.{0} Real Real.instZero))) => Filter.principal.{u} (Prod.{u, u} α α) (setOf.{u} (Prod.{u, u} α α) (fun (p : Prod.{u, u} α α) => LT.lt.{0} Real Real.instLT (Dist.dist.{u} α toDist (Prod.fst.{u, u} α α p) (Prod.snd.{u, u} α α p)) ε)))))) PseudoMetricSpace.uniformity_dist._autoParam) -> (forall (toBornology : Bornology.{u} α), (autoParam.{0} (Eq.{succ u} (Set.{u} (Set.{u} α)) (Filter.sets.{u} α (Bornology.cobounded.{u} α toBornology)) (setOf.{u} (Set.{u} α) (fun (s : Set.{u} α) => Exists.{1} Real (fun (C : Real) => forall (x : α), (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) (Compl.compl.{u} (Set.{u} α) (Set.instCompl.{u} α) s) x) -> (forall (y : α), (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) (Compl.compl.{u} (Set.{u} α) (Set.instCompl.{u} α) s) y) -> (LE.le.{0} Real Real.instLE (Dist.dist.{u} α toDist x y) C)))))) PseudoMetricSpace.cobounded_sets._autoParam) -> (PseudoMetricSpace.{u} α))))

-- Stub: this file represents the declaration `PseudoMetricSpace.mk`.
-- In a full split, the body would be extracted from the environment.
