import Split.False
import Split.congrArg
import Split.true_or
import Split.False_elim
import Split.noConfusion_of_Nat
import Split.Membership_mem
import Split.Exists
import Split.List_Perm_cons
import Split.Eq_mp
import Split.List_Perm
import Split.List_Perm_swap
import Split.List_Perm_subset
import Split.List_Perm_trans
import Split.List_Perm_swap'
import Split.List_cons
import Split.List_append
import Split.instHAppendOfAppend
import Split.List
import Split.And
import Split.Exists_casesOn
import Split.List_instMembership
import Split.True
import Split.List_casesOn
import Split.eq_self
import Split.List_append_of_mem
import Split.of_eq_true
import Split.eq_of_heq
import Split.Eq_ndrec
import Split.List_Perm_symm
import Split.Eq_refl
import Split.List_perm_middle
import Split.HEq
import Split.congrFun'
import Split.Or
import Split.and_false
import Split.List_instAppend
import Split.Eq_symm
import Split.eq_false'
import Split.or_true
import Split.Eq
import Split.List_ctorIdx
import Split.List_cons_noConfusion
import Split.HAppend_hAppend
import Split.rfl
import Split.List_Perm_recOnSwap'
import Split.Eq_trans
import Split.List_nil

-- List.perm_inv_core from environment
-- theorem List.perm_inv_core : forall {α : Type.{u_1}} {a : α} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {r₁ : List.{u_1} α} {r₂ : List.{u_1} α}, (List.Perm.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ (List.cons.{u_1} α a r₁)) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₂ (List.cons.{u_1} α a r₂))) -> (List.Perm.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ r₁) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₂ r₂))

-- Stub: this file represents the declaration `List.perm_inv_core`.
-- In a full split, the body would be extracted from the environment.
