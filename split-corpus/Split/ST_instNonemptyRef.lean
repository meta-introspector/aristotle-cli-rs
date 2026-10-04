import Mathlib

-- spec: theorem ST.instNonemptyRef : forall {σ : Type} {α : Type} [s : Nonempty.{1} α], Nonempty.{1} (ST.Ref σ α)
theorem ST.instNonemptyRef : forall {σ : Type} {α : Type} [s : Nonempty.{1} α], Nonempty.{1} (ST.Ref σ α) :=
  fun {σ : Type} {α : Type} [s : Nonempty.{1} α] => Nonempty.intro.{1} (ST.Ref σ α) (ST.Ref.mk σ α (Classical.choice.{1} (NonemptyType.type.{0} ST.RefPointed) (Subtype.property.{2} Type (fun (α : Type) => Nonempty.{1} α) ST.RefPointed)) s)
