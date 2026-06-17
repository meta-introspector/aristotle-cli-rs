import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.add_neg_cancel_right
import Split.Function_swap
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.Eq_mp
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.Covariant
import Split.instHAdd
import Split.AddGroup
import Split.Iff
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.Iff_intro
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Contravariant
import Split.SubNegMonoid_toAddMonoid
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg

-- AddGroup.covariant_swap_iff_contravariant_swap from environment
-- theorem AddGroup.covariant_swap_iff_contravariant_swap : forall {N : Type.{u_2}} {r : N -> N -> Prop} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.20 : AddGroup.{u_2} N], Iff (Covariant.{u_2, u_2} N N (Function.swap.{succ u_2, succ u_2, succ u_2} N N (fun (a._@._internal._hyg.0 : N) (a._@._internal._hyg.0 : N) => N) (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.34 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.34 : N) => HAdd.hAdd.{u_2, u_2, u_2} N N N (instHAdd.{u_2} N (AddZero.toAdd.{u_2} N (AddZeroClass.toAddZero.{u_2} N (AddMonoid.toAddZeroClass.{u_2} N (SubNegMonoid.toAddMonoid.{u_2} N (AddGroup.toSubNegMonoid.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.20)))))) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.34 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.34)) r) (Contravariant.{u_2, u_2} N N (Function.swap.{succ u_2, succ u_2, succ u_2} N N (fun (a._@._internal._hyg.0 : N) (a._@._internal._hyg.0 : N) => N) (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.53 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.53 : N) => HAdd.hAdd.{u_2, u_2, u_2} N N N (instHAdd.{u_2} N (AddZero.toAdd.{u_2} N (AddZeroClass.toAddZero.{u_2} N (AddMonoid.toAddZeroClass.{u_2} N (SubNegMonoid.toAddMonoid.{u_2} N (AddGroup.toSubNegMonoid.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.20)))))) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.53 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1964938436._hygCtx._hyg.53)) r)

-- Stub: this file represents the declaration `AddGroup.covariant_swap_iff_contravariant_swap`.
-- In a full split, the body would be extracted from the environment.
