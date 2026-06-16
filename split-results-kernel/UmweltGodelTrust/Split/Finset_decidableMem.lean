import Split.Finset
import Split.Decidable
import Split.Membership_mem
import Split.Finset_val
import Split.Finset_instSetLike
import Split.Multiset_decidableMem
import Split.SetLike_instMembership
import Split.DecidableEq

-- Finset.decidableMem from environment
-- def Finset.decidableMem : forall {α : Type.{u_1}} [_h : DecidableEq.{succ u_1} α] (a : α) (s : Finset.{u_1} α), Decidable (Membership.mem.{u_1, u_1} α (Finset.{u_1} α) (SetLike.instMembership.{u_1, u_1} (Finset.{u_1} α) α (Finset.instSetLike.{u_1} α)) s a)
-- (definition body omitted)

-- Stub: this file represents the declaration `Finset.decidableMem`.
-- In a full split, the body would be extracted from the environment.
