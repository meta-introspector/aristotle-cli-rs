import Split.List_Pairwise
import Split.congrArg
import Split.Membership_mem
import Split.iff_self
import Split.List
import Split.And
import Split.List_Pairwise_iff_of_mem
import Split.Iff
import Split.List_instMembership
import Split.congr
import Split.True
import Split.eq_true
import Split.of_eq_true
import Split.Eq_refl
import Split.congrFun'
import Split.implies_true
import Split.implies_congr_ctx
import Split.true_and
import Split.Eq_trans
import Split.forall_congr

-- List.Pairwise.and_mem from environment
-- theorem List.Pairwise.and_mem : forall {α : Type.{u_1}} {R : α -> α -> Prop} {l : List.{u_1} α}, Iff (List.Pairwise.{u_1} α R l) (List.Pairwise.{u_1} α (fun (x : α) (y : α) => And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l x) (And (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l y) (R x y))) l)

-- Stub: this file represents the declaration `List.Pairwise.and_mem`.
-- In a full split, the body would be extracted from the environment.
