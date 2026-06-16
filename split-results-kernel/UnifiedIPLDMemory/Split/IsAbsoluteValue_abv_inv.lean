import Split.GroupWithZero_toDivisionMonoid
import Split.DivisionCommMonoid_toDivisionMonoid
import Split.DivInvOneMonoid_toInvOneClass
import Split.LinearOrder
import Split.MonoidWithZeroHom_funLike
import Split.DivisionSemiring_toGroupWithZero
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.MonoidWithZeroHom_monoidWithZeroHomClass
import Split.SemilatticeInf_toPartialOrder
import Split.map_inv₀
import Split.DistribLattice_toLattice
import Split.Semifield
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.IsAbsoluteValue_abvHom'
import Split.DivisionSemiring
import Split.MonoidWithZeroHom
import Split.Inv_inv
import Split.Semifield_toDivisionSemiring
import Split.Semifield_toCommGroupWithZero
import Split.instIsCancelMulZero
import Split.IsAbsoluteValue
import Split.DivisionSemiring_toSemiring
import Split.CommGroupWithZero_toDivisionCommMonoid
import Split.InvOneClass_toInv
import Split.GroupWithZero_toNontrivial
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf

-- IsAbsoluteValue.abv_inv from environment
-- theorem IsAbsoluteValue.abv_inv : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.7 : Semifield.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.10 : LinearOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.14 : DivisionSemiring.{u_6} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.20 : IsAbsoluteValue.{u_5, u_6} S (DivisionSemiring.toSemiring.{u_5} S (Semifield.toDivisionSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.7)) (SemilatticeInf.toPartialOrder.{u_5} S (Lattice.toSemilatticeInf.{u_5} S (DistribLattice.toLattice.{u_5} S (instDistribLatticeOfLinearOrder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.10)))) R (DivisionSemiring.toSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.14) abv] (a : R), Eq.{succ u_5} S (abv (Inv.inv.{u_6} R (InvOneClass.toInv.{u_6} R (DivInvOneMonoid.toInvOneClass.{u_6} R (DivisionMonoid.toDivInvOneMonoid.{u_6} R (GroupWithZero.toDivisionMonoid.{u_6} R (DivisionSemiring.toGroupWithZero.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.14))))) a)) (Inv.inv.{u_5} S (InvOneClass.toInv.{u_5} S (DivInvOneMonoid.toInvOneClass.{u_5} S (DivisionMonoid.toDivInvOneMonoid.{u_5} S (DivisionCommMonoid.toDivisionMonoid.{u_5} S (CommGroupWithZero.toDivisionCommMonoid.{u_5} S (Semifield.toCommGroupWithZero.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3549237117._hygCtx._hyg.7)))))) (abv a))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_inv`.
-- In a full split, the body would be extracted from the environment.
