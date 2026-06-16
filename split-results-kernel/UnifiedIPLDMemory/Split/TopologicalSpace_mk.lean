import Split.Set_univ
import Split.Set_sUnion
import Split.Membership_mem
import Split.Set_instInter
import Split.Inter_inter
import Split.TopologicalSpace
import Split.Set_instMembership
import Split.Set

-- TopologicalSpace.mk from environment
-- constructor TopologicalSpace.mk : forall {X : Type.{u}} (IsOpen : (Set.{u} X) -> Prop), (IsOpen (Set.univ.{u} X)) -> (forall (s : Set.{u} X) (t : Set.{u} X), (IsOpen s) -> (IsOpen t) -> (IsOpen (Inter.inter.{u} (Set.{u} X) (Set.instInter.{u} X) s t))) -> (forall (s : Set.{u} (Set.{u} X)), (forall (t : Set.{u} X), (Membership.mem.{u, u} (Set.{u} X) (Set.{u} (Set.{u} X)) (Set.instMembership.{u} (Set.{u} X)) s t) -> (IsOpen t)) -> (IsOpen (Set.sUnion.{u} X s))) -> (TopologicalSpace.{u} X)

-- Stub: this file represents the declaration `TopologicalSpace.mk`.
-- In a full split, the body would be extracted from the environment.
