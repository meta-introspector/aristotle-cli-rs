import Mathlib

-- spec: constructor List.Lex.rel : forall {α : Type.{u}} {r : α -> α -> Prop} {a₁ : α} {l₁ : List.{u} α} {a₂ : α} {l₂ : List.{u} α}, (r a₁ a₂) -> (List.Lex.{u} α r (List.cons.{u} α a₁ l₁) (List.cons.{u} α a₂ l₂))
