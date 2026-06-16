import Split.List_Mem_tail
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.And
import Split.Iff
import Split.List_instMembership
import Split.And_intro
import Split.Iff_intro
import Split.List_Mem_head
import Split.List_Mem

-- List.forall_mem_cons from environment
-- theorem List.forall_mem_cons : forall {α : Type.{u_1}} {p : α -> Prop} {a : α} {l : List.{u_1} α}, Iff (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) (List.cons.{u_1} α a l) x) -> (p x)) (And (p a) (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l x) -> (p x)))

-- Stub: this file represents the declaration `List.forall_mem_cons`.
-- In a full split, the body would be extracted from the environment.
