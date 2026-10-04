import Mathlib

-- spec: opaque Lean.Meta.SynthInstance.MkTableKey.normExpr : Lean.Expr -> (Lean.Meta.SynthInstance.MkTableKey.M Lean.Expr)
opaque Lean.Meta.SynthInstance.MkTableKey.normExpr : Lean.Expr -> (Lean.Meta.SynthInstance.MkTableKey.M Lean.Expr) :=
  fun (e : Lean.Expr) => let inst : Inhabited.{1} Lean.Expr := Inhabited.mk.{1} Lean.Expr e; Inhabited.default.{1} (Lean.Meta.SynthInstance.MkTableKey.M Lean.Expr) (instInhabitedOfMonad.{0, 0} Lean.Expr Lean.Meta.SynthInstance.MkTableKey.M (StateT.instMonad.{0, 0} Lean.Meta.SynthInstance.MkTableKey.State Id.{0} Id.instMonad.{0}) inst)
