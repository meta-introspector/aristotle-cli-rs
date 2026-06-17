import Split.Finset
import Split.Membership_mem
import Split.Set_Elem
import Split.Iff
import Split.Fintype
import Split.Finset_instSetLike
import Split.Fintype_subtype
import Split.Set_instMembership
import Split.SetLike_instMembership
import Split.Set

-- Fintype.ofFinset from environment
-- def Fintype.ofFinset : forall {α : Type.{u_1}} {p : Set.{u_1} α} (s : Finset.{u_1} α), (forall (x : α), Iff (Membership.mem.{u_1, u_1} α (Finset.{u_1} α) (SetLike.instMembership.{u_1, u_1} (Finset.{u_1} α) α (Finset.instSetLike.{u_1} α)) s x) (Membership.mem.{u_1, u_1} α (Set.{u_1} α) (Set.instMembership.{u_1} α) p x)) -> (Fintype.{u_1} (Set.Elem.{u_1} α p))
-- (definition body omitted)

-- Stub: this file represents the declaration `Fintype.ofFinset`.
-- In a full split, the body would be extracted from the environment.
