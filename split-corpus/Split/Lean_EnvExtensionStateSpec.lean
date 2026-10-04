import Mathlib

-- spec: opaque Lean.EnvExtensionStateSpec : Sigma.{1, 0} Type (fun (α : Type) => Inhabited.{1} α)
opaque Lean.EnvExtensionStateSpec : Sigma.{1, 0} Type (fun (α : Type) => Inhabited.{1} α) :=
  Sigma.mk.{1, 0} Type (fun (α : Type) => Inhabited.{1} α) Unit (Inhabited.mk.{1} Unit Unit.unit)
