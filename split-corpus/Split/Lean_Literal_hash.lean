import Mathlib

set_option pp.all true
-- spec: Lean.Literal.hash : Lean.Literal -> UInt64
def Lean.Literal.hash : Lean.Literal -> UInt64 :=
  fun (x._@.Lean.Expr.1363585664._hygCtx._hyg.5 : Lean.Literal) => _private.Lean.Expr.0.Lean.instReprLiteral.repr.match_1.{1} (fun (x._@.Lean.Expr.1363585664._hygCtx.5.Lean.Expr.1363585664._hygCtx._hyg.16 : Lean.Literal) => UInt64) x._@.Lean.Expr.1363585664._hygCtx._hyg.5 (fun (v : Nat) => Hashable.hash.{1} Nat instHashableNat v) (fun (v : String) => Hashable.hash.{1} String instHashableString v)
