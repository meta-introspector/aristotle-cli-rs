import Mathlib

-- spec: opaque Lean.MessageData.hasTag : (Lean.Name -> Bool) -> Lean.MessageData -> Bool
opaque Lean.MessageData.hasTag : (Lean.Name -> Bool) -> Lean.MessageData -> Bool :=
  fun (p : Lean.Name -> Bool) (a._@._internal._hyg.0 : Lean.MessageData) => Inhabited.default.{1} Bool instInhabitedBool
