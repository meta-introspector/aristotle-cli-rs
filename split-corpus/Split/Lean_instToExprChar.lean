import Mathlib

set_option pp.all true
-- spec: Lean.instToExprChar : Lean.ToExpr.{0} Char
def Lean.instToExprChar : Lean.ToExpr.{0} Char :=
  Lean.ToExpr.mk.{0} Char (fun (c : Char) => Lean.mkApp (Lean.mkConst (Lean.Name.mkStr2 "Char" "ofNat") (List.nil.{0} Lean.Level)) (Lean.mkRawNatLit (Char.toNat c))) (Lean.mkConst (Lean.Name.mkStr1 "Char") (List.nil.{0} Lean.Level))
