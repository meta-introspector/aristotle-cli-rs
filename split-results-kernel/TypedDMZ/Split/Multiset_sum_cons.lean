import Split.Multiset_sum
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.Multiset
import Split.Multiset_cons
import Split.AddCommMonoid
import Split.AddZero_toZero
import Split.instHAdd
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.Multiset_foldr_cons
import Split.OfNat_ofNat
import Split.Eq

-- Multiset.sum_cons from environment
-- theorem Multiset.sum_cons : forall {M : Type.{u_3}} [inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.406885970._hygCtx._hyg.6 : AddCommMonoid.{u_3} M] (a : M) (s : Multiset.{u_3} M), Eq.{succ u_3} M (Multiset.sum.{u_3} M inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.406885970._hygCtx._hyg.6 (Multiset.cons.{u_3} M a s)) (HAdd.hAdd.{u_3, u_3, u_3} M M M (instHAdd.{u_3} M (AddZero.toAdd.{u_3} M (AddZeroClass.toAddZero.{u_3} M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.406885970._hygCtx._hyg.6))))) a (Multiset.sum.{u_3} M inst._@.Mathlib.Algebra.BigOperators.Group.Multiset.Defs.406885970._hygCtx._hyg.6 s))

-- Stub: this file represents the declaration `Multiset.sum_cons`.
-- In a full split, the body would be extracted from the environment.
