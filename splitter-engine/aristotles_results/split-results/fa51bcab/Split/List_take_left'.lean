import Split.List_take_left
import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.instHAppendOfAppend
import Split.List
import Split.Nat
import Split.List_instAppend
import Split.Eq_symm
import Split.Eq
import Split.List_take
import Split.List_length
import Split.HAppend_hAppend

-- List.take_left' from environment
-- theorem List.take_left' : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {i : Nat}, (Eq.{1} Nat (List.length.{u_1} α l₁) i) -> (Eq.{succ u_1} (List.{u_1} α) (List.take.{u_1} α i (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂)) l₁)

-- Stub: this file represents the declaration `List.take_left'`.
-- In a full split, the body would be extracted from the environment.
