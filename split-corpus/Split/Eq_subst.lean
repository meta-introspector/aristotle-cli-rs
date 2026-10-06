import Mathlib

-- spec: theorem Eq.subst : forall {α : Sort.{u}} {motive : α -> Prop} {a : α} {b : α}, (Eq.{u} α a b) -> (motive a) -> (motive b)
theorem Eq.subst : forall {α : Sort.{u}} {motive : α -> Prop} {a : α} {b : α}, (Eq.{u} α a b) -> (motive a) -> (motive b) :=
  fun {α : Sort.{u}} {motive : α -> Prop} {a : α} {b : α} (h₁ : Eq.{u} α a b) (h₂ : motive a) => Eq.ndrec.{0, u} α a motive h₂ b h₁
