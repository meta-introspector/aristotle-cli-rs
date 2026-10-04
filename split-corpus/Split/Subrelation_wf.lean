import Mathlib

-- spec: theorem Subrelation.wf : forall {α : Sort.{u}} {r : α -> α -> Prop} {q : α -> α -> Prop}, (Subrelation.{u} α q r) -> (WellFounded.{u} α r) -> (WellFounded.{u} α q)
theorem Subrelation.wf : forall {α : Sort.{u}} {r : α -> α -> Prop} {q : α -> α -> Prop}, (Subrelation.{u} α q r) -> (WellFounded.{u} α r) -> (WellFounded.{u} α q) :=
  fun {α : Sort.{u}} {r : α -> α -> Prop} {q : α -> α -> Prop} (h₁ : Subrelation.{u} α q r) (h₂ : WellFounded.{u} α r) => WellFounded.intro.{u} α q (fun (a : α) => Subrelation.accessible.{u} α r q a h₁ (WellFounded.apply.{u} α r h₂ a))
