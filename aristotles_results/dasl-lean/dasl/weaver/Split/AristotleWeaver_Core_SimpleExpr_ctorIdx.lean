import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.SimpleExpr.ctorIdx : AristotleWeaver.Core.SimpleExpr -> Nat
def AristotleWeaver.Core.SimpleExpr.ctorIdx : AristotleWeaver.Core.SimpleExpr -> Nat :=
  fun (x : AristotleWeaver.Core.SimpleExpr) => AristotleWeaver.Core.SimpleExpr.casesOn.{1} (fun (x : AristotleWeaver.Core.SimpleExpr) => Nat) x (fun (a._@._internal._hyg.0 : Nat) => 0) (fun (a._@._internal._hyg.0 : String) (a._@._internal._hyg.0 : List.{0} Nat) => 1) (fun (a._@._internal._hyg.0 : AristotleWeaver.Core.SimpleExpr) (a._@._internal._hyg.0 : AristotleWeaver.Core.SimpleExpr) => 2) (fun (a._@._internal._hyg.0 : String) (a._@._internal._hyg.0 : AristotleWeaver.Core.SimpleExpr) (a._@._internal._hyg.0 : AristotleWeaver.Core.SimpleExpr) => 3) (fun (a._@._internal._hyg.0 : String) (a._@._internal._hyg.0 : AristotleWeaver.Core.SimpleExpr) (a._@._internal._hyg.0 : AristotleWeaver.Core.SimpleExpr) => 4)
