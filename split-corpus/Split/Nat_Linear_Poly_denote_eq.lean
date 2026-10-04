import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Poly.denote_eq : Nat.Linear.Context -> (Prod.{0, 0} Nat.Linear.Poly Nat.Linear.Poly) -> Prop
def Nat.Linear.Poly.denote_eq : Nat.Linear.Context -> (Prod.{0, 0} Nat.Linear.Poly Nat.Linear.Poly) -> Prop :=
  fun (ctx : Nat.Linear.Context) (mp : Prod.{0, 0} Nat.Linear.Poly Nat.Linear.Poly) => Eq.{1} Nat (Nat.Linear.Poly.denote ctx (Prod.fst.{0, 0} Nat.Linear.Poly Nat.Linear.Poly mp)) (Nat.Linear.Poly.denote ctx (Prod.snd.{0, 0} Nat.Linear.Poly Nat.Linear.Poly mp))
