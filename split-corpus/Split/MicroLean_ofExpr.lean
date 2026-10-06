import Mathlib

-- spec: opaque MicroLean.ofExpr : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} MicroLean.MicroLeanType))
opaque MicroLean.ofExpr : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} MicroLean.MicroLeanType)) :=
  fun (e : Lean.Expr) => Inhabited.default.{1} (Lean.Meta.MetaM (Option.{0} MicroLean.MicroLeanType)) (Lean.Meta.instInhabitedMetaM (Option.{0} MicroLean.MicroLeanType))
