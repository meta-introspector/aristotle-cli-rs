import Mathlib

set_option pp.all true
-- spec: Lean.Expr.betaRev : Lean.Expr -> (Array.{0} Lean.Expr) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> Lean.Expr
def Lean.Expr.betaRev : Lean.Expr -> (Array.{0} Lean.Expr) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> Lean.Expr :=
  fun (f : Lean.Expr) (revArgs : Array.{0} Lean.Expr) (useZeta : Bool) (preserveMData : Bool) => ite.{1} Lean.Expr (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (Array.size.{0} Lean.Expr revArgs) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.true) (instDecidableEqBool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (Array.size.{0} Lean.Expr revArgs) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) Bool.true) f (have sz : Nat := Array.size.{0} Lean.Expr revArgs; _private.Lean.Expr.0.Lean.Expr.betaRev.go revArgs useZeta preserveMData sz f (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
