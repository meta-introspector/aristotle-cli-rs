import Split.Finset
import Split.Membership_mem
import Split.Subtype
import Split.Finset_val
import Split.Subtype_mk
import Split.Iff
import Split.Multiset_pmap
import Split.Fintype
import Split.Finset_instSetLike
import Split.Fintype_mk
import Split.Finset_mk
import Split.SetLike_instMembership

-- Fintype.subtype from environment
-- def Fintype.subtype : forall {α : Type.{u_1}} {p : α -> Prop} (s : Finset.{u_1} α), (forall (x : α), Iff (Membership.mem.{u_1, u_1} α (Finset.{u_1} α) (SetLike.instMembership.{u_1, u_1} (Finset.{u_1} α) α (Finset.instSetLike.{u_1} α)) s x) (p x)) -> (Fintype.{u_1} (Subtype.{succ u_1} α (fun (x : α) => p x)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Fintype.subtype`.
-- In a full split, the body would be extracted from the environment.
