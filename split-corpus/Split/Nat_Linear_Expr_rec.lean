import Mathlib

-- spec: recursor Nat.Linear.Expr.rec : forall {motive : Nat.Linear.Expr -> Sort.{u}}, (forall (v : Nat), motive (Nat.Linear.Expr.num v)) -> (forall (i : Nat.Linear.Var), motive (Nat.Linear.Expr.var i)) -> (forall (a : Nat.Linear.Expr) (b : Nat.Linear.Expr), (motive a) -> (motive b) -> (motive (Nat.Linear.Expr.add a b))) -> (forall (k : Nat) (a : Nat.Linear.Expr), (motive a) -> (motive (Nat.Linear.Expr.mulL k a))) -> (forall (a : Nat.Linear.Expr) (k : Nat), (motive a) -> (motive (Nat.Linear.Expr.mulR a k))) -> (forall (t : Nat.Linear.Expr), motive t)
