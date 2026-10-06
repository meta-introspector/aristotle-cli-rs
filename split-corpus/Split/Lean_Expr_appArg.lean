import Mathlib

set_option pp.all true
-- spec: Lean.Expr.appArg : forall (e : Lean.Expr), (Eq.{1} Bool (Lean.Expr.isApp e) Bool.true) -> Lean.Expr
def Lean.Expr.appArg : forall (e : Lean.Expr), (Eq.{1} Bool (Lean.Expr.isApp e) Bool.true) -> Lean.Expr :=
  fun (e : Lean.Expr) (h : Eq.{1} Bool (Lean.Expr.isApp e) Bool.true) => _private.Lean.Expr.0.Lean.Expr.appArg.match_1.{1} (fun (e._@.Lean.Expr.2227147086._hygCtx._hyg.9 : Lean.Expr) (h._@.Lean.Expr.2227147086._hygCtx._hyg.11 : Eq.{1} Bool (Lean.Expr.isApp e._@.Lean.Expr.2227147086._hygCtx._hyg.9) Bool.true) => Lean.Expr) e h (fun (fn._@.Lean.Expr.2227147086._hygCtx._hyg.22 : Lean.Expr) (a : Lean.Expr) (x._@.Lean.Expr.2227147086._hygCtx._hyg.23 : Eq.{1} Bool (Lean.Expr.isApp (Lean.Expr.app fn._@.Lean.Expr.2227147086._hygCtx._hyg.22 a)) Bool.true) => a)
