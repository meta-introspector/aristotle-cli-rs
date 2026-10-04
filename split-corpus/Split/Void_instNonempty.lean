import Mathlib

-- spec: theorem Void.instNonempty : forall {σ : Type}, Nonempty.{1} (Void σ)
theorem Void.instNonempty : forall {σ : Type}, Nonempty.{1} (Void σ) :=
  fun {σ : Type} => Subtype.property.{2} Type (fun (α : Type) => Nonempty.{1} α) (Void.nonemptyType σ)
