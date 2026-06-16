import Split.Set_univ
import Split.Membership_mem
import Split.HasSubset_Subset
import Split.Set_instInter
import Split.Inter_inter
import Split.Set_instMembership
import Split.Filter
import Split.Set_instHasSubset
import Split.Set

-- Filter.mk from environment
-- constructor Filter.mk : forall {α : Type.{u_1}} (sets : Set.{u_1} (Set.{u_1} α)), (Membership.mem.{u_1, u_1} (Set.{u_1} α) (Set.{u_1} (Set.{u_1} α)) (Set.instMembership.{u_1} (Set.{u_1} α)) sets (Set.univ.{u_1} α)) -> (forall {x : Set.{u_1} α} {y : Set.{u_1} α}, (Membership.mem.{u_1, u_1} (Set.{u_1} α) (Set.{u_1} (Set.{u_1} α)) (Set.instMembership.{u_1} (Set.{u_1} α)) sets x) -> (HasSubset.Subset.{u_1} (Set.{u_1} α) (Set.instHasSubset.{u_1} α) x y) -> (Membership.mem.{u_1, u_1} (Set.{u_1} α) (Set.{u_1} (Set.{u_1} α)) (Set.instMembership.{u_1} (Set.{u_1} α)) sets y)) -> (forall {x : Set.{u_1} α} {y : Set.{u_1} α}, (Membership.mem.{u_1, u_1} (Set.{u_1} α) (Set.{u_1} (Set.{u_1} α)) (Set.instMembership.{u_1} (Set.{u_1} α)) sets x) -> (Membership.mem.{u_1, u_1} (Set.{u_1} α) (Set.{u_1} (Set.{u_1} α)) (Set.instMembership.{u_1} (Set.{u_1} α)) sets y) -> (Membership.mem.{u_1, u_1} (Set.{u_1} α) (Set.{u_1} (Set.{u_1} α)) (Set.instMembership.{u_1} (Set.{u_1} α)) sets (Inter.inter.{u_1} (Set.{u_1} α) (Set.instInter.{u_1} α) x y))) -> (Filter.{u_1} α)

-- Stub: this file represents the declaration `Filter.mk`.
-- In a full split, the body would be extracted from the environment.
