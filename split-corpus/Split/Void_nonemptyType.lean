import Mathlib

-- spec: opaque Void.nonemptyType : Type -> NonemptyType.{0}
opaque Void.nonemptyType : Type -> NonemptyType.{0} :=
  fun (σ : Type) => Inhabited.default.{2} NonemptyType.{0} instInhabitedNonemptyType.{0}
