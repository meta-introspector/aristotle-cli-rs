import Split.List_Pairwise
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.List_instMembership

-- List.Pairwise.cons from environment
-- constructor List.Pairwise.cons : forall {α : Type.{u}} {R : α -> α -> Prop} {a : α} {l : List.{u} α}, (forall (a' : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l a') -> (R a a')) -> (List.Pairwise.{u} α R l) -> (List.Pairwise.{u} α R (List.cons.{u} α a l))

-- Stub: this file represents the declaration `List.Pairwise.cons`.
-- In a full split, the body would be extracted from the environment.
