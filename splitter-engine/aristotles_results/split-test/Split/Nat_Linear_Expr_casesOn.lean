import Split.Nat_Linear_Expr_mulL
import Split.Nat_Linear_Expr
import Split.Nat_Linear_Expr_num
import Split.Nat_Linear_Var
import Split.Nat
import Split.Nat_Linear_Expr_add
import Split.Nat_Linear_Expr_mulR
import Split.Nat_Linear_Expr_rec
import Split.Nat_Linear_Expr_var

-- Nat.Linear.Expr.casesOn from environment
-- def Nat.Linear.Expr.casesOn : forall {motive : Nat.Linear.Expr -> Sort.{u}} (t : Nat.Linear.Expr), (forall (v : Nat), motive (Nat.Linear.Expr.num v)) -> (forall (i : Nat.Linear.Var), motive (Nat.Linear.Expr.var i)) -> (forall (a : Nat.Linear.Expr) (b : Nat.Linear.Expr), motive (Nat.Linear.Expr.add a b)) -> (forall (k : Nat) (a : Nat.Linear.Expr), motive (Nat.Linear.Expr.mulL k a)) -> (forall (a : Nat.Linear.Expr) (k : Nat), motive (Nat.Linear.Expr.mulR a k)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.Linear.Expr.casesOn`.
-- In a full split, the body would be extracted from the environment.
