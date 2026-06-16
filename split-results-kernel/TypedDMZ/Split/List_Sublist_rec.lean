import Split.List_cons
import Split.List
import Split.List_Sublist_slnil
import Split.List_Sublist
import Split.List_Sublist_cons
import Split.List_Sublist_cons₂
import Split.List_nil

-- List.Sublist.rec from environment
-- recursor List.Sublist.rec : forall {α : Type.{u_1}} {motive : forall (a._@._internal._hyg.0 : List.{u_1} α) (a_1._@._internal._hyg.0 : List.{u_1} α), (List.Sublist.{u_1} α a._@._internal._hyg.0 a_1._@._internal._hyg.0) -> Prop}, (motive (List.nil.{u_1} α) (List.nil.{u_1} α) (List.Sublist.slnil.{u_1} α)) -> (forall {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} (a : α) (a._@._internal._hyg.0 : List.Sublist.{u_1} α l₁ l₂), (motive l₁ l₂ a._@._internal._hyg.0) -> (motive l₁ (List.cons.{u_1} α a l₂) (List.Sublist.cons.{u_1} α l₁ l₂ a a._@._internal._hyg.0))) -> (forall {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} (a : α) (a._@._internal._hyg.0 : List.Sublist.{u_1} α l₁ l₂), (motive l₁ l₂ a._@._internal._hyg.0) -> (motive (List.cons.{u_1} α a l₁) (List.cons.{u_1} α a l₂) (List.Sublist.cons₂.{u_1} α l₁ l₂ a a._@._internal._hyg.0))) -> (forall {a._@._internal._hyg.0 : List.{u_1} α} {a_1._@._internal._hyg.0 : List.{u_1} α} (t : List.Sublist.{u_1} α a._@._internal._hyg.0 a_1._@._internal._hyg.0), motive a._@._internal._hyg.0 a_1._@._internal._hyg.0 t)

-- Stub: this file represents the declaration `List.Sublist.rec`.
-- In a full split, the body would be extracted from the environment.
