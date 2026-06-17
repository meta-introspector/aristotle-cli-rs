import Split.Eq_mpr
import Split.congrArg
import Split.Membership_mem
import Split.Exists
import Split.id
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.List_instMembership
import Split.List_Mem_brecOn
import Split.Exists_intro
import Split.Eq_refl
import Split.List_Mem_below
import Split.List_instAppend
import Split.List_Mem
import Split.Eq
import Split.List_cons_append
import Split.HAppend_hAppend
import Split.rfl
import Split.List_nil

-- List.append_of_mem from environment
-- theorem List.append_of_mem : forall {α : Type.{u_1}} {a : α} {l : List.{u_1} α}, (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (Exists.{succ u_1} (List.{u_1} α) (fun (s : List.{u_1} α) => Exists.{succ u_1} (List.{u_1} α) (fun (t : List.{u_1} α) => Eq.{succ u_1} (List.{u_1} α) l (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) s (List.cons.{u_1} α a t)))))

-- Stub: this file represents the declaration `List.append_of_mem`.
-- In a full split, the body would be extracted from the environment.
