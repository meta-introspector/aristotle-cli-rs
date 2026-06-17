import Split.UniformSpace
import Split.Preorder_toLT
import Split.iInf
import Split.Filter_instInfSet
import Split.UniformSpace_ofCore
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.setOf
import Split.Preorder_toLE
import Split.Exists
import Split.AddZeroClass_toAddZero
import Split.PartialOrder
import Split.LE_le
import Split.Prod_fst
import Split.AddCommMonoid
import Split.AddZero_toZero
import Split.GT_gt
import Split.instHAdd
import Split.And
import Split.HAdd_hAdd
import Split.LT_lt
import Split.Filter_principal
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.AddCommSemigroup_toAddCommMagma
import Split.UniformSpace_Core_mk
import Split.Prod
import Split.OfNat_ofNat
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Eq
import Split.Prod_snd
import Split.Filter
import Split.AddCommMagma_toAdd

-- UniformSpace.ofFun from environment
-- def UniformSpace.ofFun : forall {X : Type.{u_1}} {M : Type.{u_2}} [inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.4 : AddCommMonoid.{u_2} M] [inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7 : PartialOrder.{u_2} M] (d : X -> X -> M), (forall (x : X), Eq.{succ u_2} M (d x x) (OfNat.ofNat.{u_2} M 0 (Zero.toOfNat0.{u_2} M (AddZero.toZero.{u_2} M (AddZeroClass.toAddZero.{u_2} M (AddMonoid.toAddZeroClass.{u_2} M (AddCommMonoid.toAddMonoid.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.4))))))) -> (forall (x : X) (y : X), Eq.{succ u_2} M (d x y) (d y x)) -> (forall (x : X) (y : X) (z : X), LE.le.{u_2} M (Preorder.toLE.{u_2} M (PartialOrder.toPreorder.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7)) (d x z) (HAdd.hAdd.{u_2, u_2, u_2} M M M (instHAdd.{u_2} M (AddCommMagma.toAdd.{u_2} M (AddCommSemigroup.toAddCommMagma.{u_2} M (AddCommMonoid.toAddCommSemigroup.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.4)))) (d x y) (d y z))) -> (forall (ε : M), (GT.gt.{u_2} M (Preorder.toLT.{u_2} M (PartialOrder.toPreorder.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7)) ε (OfNat.ofNat.{u_2} M 0 (Zero.toOfNat0.{u_2} M (AddZero.toZero.{u_2} M (AddZeroClass.toAddZero.{u_2} M (AddMonoid.toAddZeroClass.{u_2} M (AddCommMonoid.toAddMonoid.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.4))))))) -> (Exists.{succ u_2} M (fun (δ : M) => And (GT.gt.{u_2} M (Preorder.toLT.{u_2} M (PartialOrder.toPreorder.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7)) δ (OfNat.ofNat.{u_2} M 0 (Zero.toOfNat0.{u_2} M (AddZero.toZero.{u_2} M (AddZeroClass.toAddZero.{u_2} M (AddMonoid.toAddZeroClass.{u_2} M (AddCommMonoid.toAddMonoid.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.4))))))) (forall (x : M), (LT.lt.{u_2} M (Preorder.toLT.{u_2} M (PartialOrder.toPreorder.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7)) x δ) -> (forall (y : M), (LT.lt.{u_2} M (Preorder.toLT.{u_2} M (PartialOrder.toPreorder.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7)) y δ) -> (LT.lt.{u_2} M (Preorder.toLT.{u_2} M (PartialOrder.toPreorder.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.7)) (HAdd.hAdd.{u_2, u_2, u_2} M M M (instHAdd.{u_2} M (AddCommMagma.toAdd.{u_2} M (AddCommSemigroup.toAddCommMagma.{u_2} M (AddCommMonoid.toAddCommSemigroup.{u_2} M inst._@.Mathlib.Topology.UniformSpace.OfFun.3577906235._hygCtx._hyg.4)))) x y) ε)))))) -> (UniformSpace.{u_1} X)
-- (definition body omitted)

-- Stub: this file represents the declaration `UniformSpace.ofFun`.
-- In a full split, the body would be extracted from the environment.
