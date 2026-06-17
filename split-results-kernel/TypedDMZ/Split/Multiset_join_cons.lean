import Split.Multiset_instAddCancelCommMonoid
import Split.Multiset
import Split.Multiset_cons
import Split.instHAdd
import Split.HAdd_hAdd
import Split.AddCancelCommMonoid_toAddCommMonoid
import Split.Multiset_join
import Split.Multiset_sum_cons
import Split.Eq
import Split.Multiset_instAdd

-- Multiset.join_cons from environment
-- theorem Multiset.join_cons : forall {α : Type.{u_1}} (s : Multiset.{u_1} α) (S : Multiset.{u_1} (Multiset.{u_1} α)), Eq.{succ u_1} (Multiset.{u_1} α) (Multiset.join.{u_1} α (Multiset.cons.{u_1} (Multiset.{u_1} α) s S)) (HAdd.hAdd.{u_1, u_1, u_1} (Multiset.{u_1} α) (Multiset.{u_1} α) (Multiset.{u_1} α) (instHAdd.{u_1} (Multiset.{u_1} α) (Multiset.instAdd.{u_1} α)) s (Multiset.join.{u_1} α S))

-- Stub: this file represents the declaration `Multiset.join_cons`.
-- In a full split, the body would be extracted from the environment.
