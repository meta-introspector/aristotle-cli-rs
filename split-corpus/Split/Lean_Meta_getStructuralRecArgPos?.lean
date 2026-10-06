import Mathlib

-- spec: opaque Lean.Meta.getStructuralRecArgPos? : Lean.Name -> (Lean.Core.CoreM (Option.{0} Nat))
opaque Lean.Meta.getStructuralRecArgPos? : Lean.Name -> (Lean.Core.CoreM (Option.{0} Nat)) :=
  fun (declName : Lean.Name) => Inhabited.default.{1} (Lean.Core.CoreM (Option.{0} Nat)) (Lean.Core.instInhabitedCoreM (Option.{0} Nat))
