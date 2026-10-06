import Mathlib

set_option pp.all true
-- spec: Lean.Meta.isConstructorApp? : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} Lean.ConstructorVal))
def Lean.Meta.isConstructorApp? : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} Lean.ConstructorVal)) :=
  fun (e : Lean.Expr) => Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Expr (Option.{0} Lean.ConstructorVal) (Lean.Meta.litToCtor e) (fun (__do_lift._@.Lean.Meta.CtorRecognizer.821427825._hygCtx._hyg.13.0 : Lean.Expr) => Lean.Meta.isConstructorAppCore? __do_lift._@.Lean.Meta.CtorRecognizer.821427825._hygCtx._hyg.13.0)
