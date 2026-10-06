import Mathlib

set_option pp.all true
-- spec: Lean.Expr.ctorIdx : Lean.Expr -> Nat
def Lean.Expr.ctorIdx : Lean.Expr -> Nat :=
  fun (x : Lean.Expr) => Lean.Expr.casesOn.{1} (fun (x : Lean.Expr) => Nat) x (fun (deBruijnIndex : Nat) => 0) (fun (fvarId : Lean.FVarId) => 1) (fun (mvarId : Lean.MVarId) => 2) (fun (u : Lean.Level) => 3) (fun (declName : Lean.Name) (us : List.{0} Lean.Level) => 4) (fun (fn : Lean.Expr) (arg : Lean.Expr) => 5) (fun (binderName : Lean.Name) (binderType : Lean.Expr) (body : Lean.Expr) (binderInfo : Lean.BinderInfo) => 6) (fun (binderName : Lean.Name) (binderType : Lean.Expr) (body : Lean.Expr) (binderInfo : Lean.BinderInfo) => 7) (fun (declName : Lean.Name) (type : Lean.Expr) (value : Lean.Expr) (body : Lean.Expr) (nondep : Bool) => 8) (fun (a._@._internal._hyg.0 : Lean.Literal) => 9) (fun (data : Lean.MData) (expr : Lean.Expr) => 10) (fun (typeName : Lean.Name) (idx : Nat) (struct : Lean.Expr) => 11)
