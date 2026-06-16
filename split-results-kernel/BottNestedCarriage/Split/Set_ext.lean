import Split.Membership_mem
import Split.funext
import Split.Iff
import Split.propext
import Split.Eq
import Split.Set_instMembership
import Split.Set

-- Set.ext from environment
-- theorem Set.ext : forall {α : Type.{u}} {a : Set.{u} α} {b : Set.{u} α}, (forall (x : α), Iff (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) a x) (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) b x)) -> (Eq.{succ u} (Set.{u} α) a b)

-- Stub: this file represents the declaration `Set.ext`.
-- In a full split, the body would be extracted from the environment.
