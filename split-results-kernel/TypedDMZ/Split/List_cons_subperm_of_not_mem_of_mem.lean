import Split.HEq_refl
import Split.List_Mem_tail
import Split.False_elim
import Split.noConfusion_of_Nat
import Split.Membership_mem
import Split.Exists
import Split.List_Perm_cons
import Split.mt
import Split.Eq_rec
import Split.Eq_mp
import Split.Or_resolve_left
import Split.List_Perm
import Split.List_Perm_swap
import Split.List_Perm_subset
import Split.List_Perm_trans
import Split.List_Sublist_subset
import Split.List_cons
import Split.And_casesOn
import Split.instHAppendOfAppend
import Split.List
import Split.And
import Split.Exists_casesOn
import Split.List_instMembership
import Split.List_Subperm
import Split.And_intro
import Split.True
import Split.Exists_intro
import Split.List_Mem_head
import Split.List_append_of_mem
import Split.of_eq_true
import Split.Eq_ndrec
import Split.List_Sublist
import Split.List_Perm_symm
import Split.Eq_refl
import Split.List_perm_middle
import Split.HEq
import Split.List_Sublist_rec
import Split.Or
import Split.List_Perm_cons_inv
import Split.List_mem_cons_self
import Split.List_instAppend
import Split.Eq_symm
import Split.List_Mem
import Split.List_Sublist_cons
import Split.Eq
import Split.List_ctorIdx
import Split.List_Mem_casesOn
import Split.Not
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_Sublist_cons₂
import Split.List_nil

-- List.cons_subperm_of_not_mem_of_mem from environment
-- theorem List.cons_subperm_of_not_mem_of_mem : forall {α : Type.{u_1}} {a : α} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, (Not (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l₁ a)) -> (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l₂ a) -> (List.Subperm.{u_1} α l₁ l₂) -> (List.Subperm.{u_1} α (List.cons.{u_1} α a l₁) l₂)

-- Stub: this file represents the declaration `List.cons_subperm_of_not_mem_of_mem`.
-- In a full split, the body would be extracted from the environment.
