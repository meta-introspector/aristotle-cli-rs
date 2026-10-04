import Mathlib

set_option pp.all true
-- spec: Lean.Meta.project? : Lean.Expr -> Nat -> (Lean.Meta.MetaM (Option.{0} Lean.Expr))
def Lean.Meta.project? : Lean.Expr -> Nat -> (Lean.Meta.MetaM (Option.{0} Lean.Expr)) :=
  fun (e : Lean.Expr) (i : Nat) => Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Expr (Option.{0} Lean.Expr) (Lean.Meta.whnf e) (fun (__do_lift._@.Lean.Meta.WHNF.3547976827._hygCtx._hyg.14.0 : Lean.Expr) => Lean.Meta.projectCore? __do_lift._@.Lean.Meta.WHNF.3547976827._hygCtx._hyg.14.0 i)
