import Mathlib

-- spec: theorem instNonemptyOfInhabited : forall {α : Sort.{u}} [inst._@.Init.Prelude.3898850658._hygCtx._hyg.3 : Inhabited.{u} α], Nonempty.{u} α
theorem instNonemptyOfInhabited : forall {α : Sort.{u}} [inst._@.Init.Prelude.3898850658._hygCtx._hyg.3 : Inhabited.{u} α], Nonempty.{u} α :=
  fun {α : Sort.{u}} [inst._@.Init.Prelude.3898850658._hygCtx._hyg.3 : Inhabited.{u} α] => Nonempty.intro.{u} α (Inhabited.default.{u} α inst._@.Init.Prelude.3898850658._hygCtx._hyg.3)
