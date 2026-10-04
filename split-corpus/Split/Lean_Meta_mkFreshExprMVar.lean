import Mathlib

set_option pp.all true
-- spec: Lean.Meta.mkFreshExprMVar : (Option.{0} Lean.Expr) -> (optParam.{1} Lean.MetavarKind Lean.MetavarKind.natural) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> (Lean.Meta.MetaM Lean.Expr)
def Lean.Meta.mkFreshExprMVar : (Option.{0} Lean.Expr) -> (optParam.{1} Lean.MetavarKind Lean.MetavarKind.natural) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> (Lean.Meta.MetaM Lean.Expr) :=
  fun (type? : Option.{0} Lean.Expr) (kind : Lean.MetavarKind) (userName : Lean.Name) => _private.Lean.Meta.Basic.0.Lean.Meta.mkFreshExprMVarImpl type? kind userName
