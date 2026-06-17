import Split.Multiset_sum
import Split.instHSMul
import Split.List_sum_replicate
import Split.congrArg
import Split.AddMonoid_toNSMul
import Split.AddCommMonoid
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.HSMul_hSMul
import Split.congrFun'
import Split.AddCommMonoid_toAddMonoid
import Split.Multiset_replicate
import Split.Eq
import Split.Eq_trans

-- Multiset.sum_replicate from environment
-- theorem Multiset.sum_replicate : forall {M : Type.{u_3}} [inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.4016319618._hygCtx._hyg.6 : AddCommMonoid.{u_3} M] (n : Nat) (a : M), Eq.{succ u_3} M (Multiset.sum.{u_3} M inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.4016319618._hygCtx._hyg.6 (Multiset.replicate.{u_3} M n a)) (HSMul.hSMul.{0, u_3, u_3} Nat M M (instHSMul.{0, u_3} Nat M (AddMonoid.toNSMul.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.4016319618._hygCtx._hyg.6))) n a)

-- Stub: this file represents the declaration `Multiset.sum_replicate`.
-- In a full split, the body would be extracted from the environment.
