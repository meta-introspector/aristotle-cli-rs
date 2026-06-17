import Split.List_Perm_cons
import Split.List_Perm
import Split.List_Perm_swap
import Split.List_Perm_trans
import Split.List_cons
import Split.List
import Split.List_Perm_rec
import Split.List_Perm_nil
import Split.List_nil

-- List.Perm.recOn from environment
-- def List.Perm.recOn : forall {α : Type.{u}} {motive : forall (a._@._internal._hyg.0 : List.{u} α) (a_1._@._internal._hyg.0 : List.{u} α), (List.Perm.{u} α a._@._internal._hyg.0 a_1._@._internal._hyg.0) -> Prop} {a._@._internal._hyg.0 : List.{u} α} {a_1._@._internal._hyg.0 : List.{u} α} (t : List.Perm.{u} α a._@._internal._hyg.0 a_1._@._internal._hyg.0), (motive (List.nil.{u} α) (List.nil.{u} α) (List.Perm.nil.{u} α)) -> (forall (x : α) {l₁ : List.{u} α} {l₂ : List.{u} α} (a._@._internal._hyg.0 : List.Perm.{u} α l₁ l₂), (motive l₁ l₂ a._@._internal._hyg.0) -> (motive (List.cons.{u} α x l₁) (List.cons.{u} α x l₂) (List.Perm.cons.{u} α x l₁ l₂ a._@._internal._hyg.0))) -> (forall (x : α) (y : α) (l : List.{u} α), motive (List.cons.{u} α y (List.cons.{u} α x l)) (List.cons.{u} α x (List.cons.{u} α y l)) (List.Perm.swap.{u} α x y l)) -> (forall {l₁ : List.{u} α} {l₂ : List.{u} α} {l₃ : List.{u} α} (a._@._internal._hyg.0 : List.Perm.{u} α l₁ l₂) (a_1._@._internal._hyg.0 : List.Perm.{u} α l₂ l₃), (motive l₁ l₂ a._@._internal._hyg.0) -> (motive l₂ l₃ a_1._@._internal._hyg.0) -> (motive l₁ l₃ (List.Perm.trans.{u} α l₁ l₂ l₃ a._@._internal._hyg.0 a_1._@._internal._hyg.0))) -> (motive a._@._internal._hyg.0 a_1._@._internal._hyg.0 t)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.Perm.recOn`.
-- In a full split, the body would be extracted from the environment.
