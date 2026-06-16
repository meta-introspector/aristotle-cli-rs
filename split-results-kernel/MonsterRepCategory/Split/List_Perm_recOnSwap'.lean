import Split.List_Perm_recOn
import Split.List_Perm_cons
import Split.List_Perm
import Split.List_Perm_refl
import Split.List_Perm_trans
import Split.List_Perm_swap'
import Split.List_cons
import Split.List
import Split.List_recOn
import Split.List_Perm_nil
import Split.List_nil

-- List.Perm.recOnSwap' from environment
-- theorem List.Perm.recOnSwap' : forall {α : Type.{u_1}} {motive : forall (l₁ : List.{u_1} α) (l₂ : List.{u_1} α), (List.Perm.{u_1} α l₁ l₂) -> Prop} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} (p : List.Perm.{u_1} α l₁ l₂), (motive (List.nil.{u_1} α) (List.nil.{u_1} α) (List.Perm.nil.{u_1} α)) -> (forall (x : α) {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} (h : List.Perm.{u_1} α l₁ l₂), (motive l₁ l₂ h) -> (motive (List.cons.{u_1} α x l₁) (List.cons.{u_1} α x l₂) (List.Perm.cons.{u_1} α x l₁ l₂ h))) -> (forall (x : α) (y : α) {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} (h : List.Perm.{u_1} α l₁ l₂), (motive l₁ l₂ h) -> (motive (List.cons.{u_1} α y (List.cons.{u_1} α x l₁)) (List.cons.{u_1} α x (List.cons.{u_1} α y l₂)) (List.Perm.swap'.{u_1} α x y l₁ l₂ h))) -> (forall {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {l₃ : List.{u_1} α} (h₁ : List.Perm.{u_1} α l₁ l₂) (h₂ : List.Perm.{u_1} α l₂ l₃), (motive l₁ l₂ h₁) -> (motive l₂ l₃ h₂) -> (motive l₁ l₃ (List.Perm.trans.{u_1} α l₁ l₂ l₃ h₁ h₂))) -> (motive l₁ l₂ p)

-- Stub: this file represents the declaration `List.Perm.recOnSwap'`.
-- In a full split, the body would be extracted from the environment.
