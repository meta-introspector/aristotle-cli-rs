import Split.Eq_mpr
import Split.congrArg
import Split.LeftCommutative
import Split.id
import Split.List_Perm
import Split.LeftCommutative_left_comm
import Split.List_cons
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_refl
import Split.congrFun'
import Split.List_foldr
import Split.Eq
import Split.List_Perm_recOnSwap'
import Split.Eq_trans
import Split.List_nil

-- List.Perm.foldr_eq from environment
-- theorem List.Perm.foldr_eq : forall {α : Type.{u_1}} {β : Type.{u_2}} {f : α -> β -> β} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} [lcomm : LeftCommutative.{succ u_1, succ u_2} α β f], (List.Perm.{u_1} α l₁ l₂) -> (forall (b : β), Eq.{succ u_2} β (List.foldr.{u_1, u_2} α β f b l₁) (List.foldr.{u_1, u_2} α β f b l₂))

-- Stub: this file represents the declaration `List.Perm.foldr_eq`.
-- In a full split, the body would be extracted from the environment.
