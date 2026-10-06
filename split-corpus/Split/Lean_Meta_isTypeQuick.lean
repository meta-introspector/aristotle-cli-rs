import Mathlib

-- spec: opaque Lean.Meta.isTypeQuick : Lean.Expr -> (Lean.Meta.MetaM Lean.LBool)
opaque Lean.Meta.isTypeQuick : Lean.Expr -> (Lean.Meta.MetaM Lean.LBool) :=
  fun (a._@._internal._hyg.0 : Lean.Expr) => Inhabited.default.{1} (Lean.Meta.MetaM Lean.LBool) (Lean.Meta.instInhabitedMetaM Lean.LBool)
