import Mathlib

set_option pp.all true
-- spec: Lean.mkConst : Lean.Name -> (optParam.{1} (List.{0} Lean.Level) (List.nil.{0} Lean.Level)) -> Lean.Expr
def Lean.mkConst : Lean.Name -> (optParam.{1} (List.{0} Lean.Level) (List.nil.{0} Lean.Level)) -> Lean.Expr :=
  fun (declName : Lean.Name) (us : List.{0} Lean.Level) => Lean.Expr.const declName us
