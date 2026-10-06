import Mathlib

-- spec: theorem instNonemptyDynamic : Nonempty.{1} Dynamic
theorem instNonemptyDynamic : Nonempty.{1} Dynamic :=
  Subtype.property.{2} Type (fun (α : Type) => Nonempty.{1} α) _private.Init.Dynamic.0.DynamicPointed
