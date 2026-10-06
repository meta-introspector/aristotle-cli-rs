import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Expr.below : forall {motive : Nat.Linear.Expr -> Sort.{u}}, Nat.Linear.Expr -> Sort.{max 1 u}
def Nat.Linear.Expr.below : forall {motive : Nat.Linear.Expr -> Sort.{u}}, Nat.Linear.Expr -> Sort.{max 1 u} :=
  fun {motive : Nat.Linear.Expr -> Sort.{u}} (t : Nat.Linear.Expr) => Nat.Linear.Expr.rec.{succ (max 1 u)} (fun (t : Nat.Linear.Expr) => Sort.{max 1 u}) (fun (v : Nat) => PUnit.{max 1 u}) (fun (i : Nat.Linear.Var) => PUnit.{max 1 u}) (fun (a : Nat.Linear.Expr) (b : Nat.Linear.Expr) (a_ih : Sort.{max 1 u}) (b_ih : Sort.{max 1 u}) => PProd.{max 1 u, max 1 u} (PProd.{u, max 1 u} (motive a) a_ih) (PProd.{u, max 1 u} (motive b) b_ih)) (fun (k : Nat) (a : Nat.Linear.Expr) (a_ih : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive a) a_ih) (fun (a : Nat.Linear.Expr) (k : Nat) (a_ih : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive a) a_ih) t
