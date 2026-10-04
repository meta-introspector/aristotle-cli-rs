import Mathlib

set_option pp.all true
-- spec: Nat.Linear.PolyCnstr.denote : Nat.Linear.Context -> Nat.Linear.PolyCnstr -> Prop
def Nat.Linear.PolyCnstr.denote : Nat.Linear.Context -> Nat.Linear.PolyCnstr -> Prop :=
  fun (ctx : Nat.Linear.Context) (c : Nat.Linear.PolyCnstr) => cond.{1} Prop (Nat.Linear.PolyCnstr.eq c) (Nat.Linear.Poly.denote_eq ctx (Prod.mk.{0, 0} Nat.Linear.Poly Nat.Linear.Poly (Nat.Linear.PolyCnstr.lhs c) (Nat.Linear.PolyCnstr.rhs c))) (Nat.Linear.Poly.denote_le ctx (Prod.mk.{0, 0} Nat.Linear.Poly Nat.Linear.Poly (Nat.Linear.PolyCnstr.lhs c) (Nat.Linear.PolyCnstr.rhs c)))
