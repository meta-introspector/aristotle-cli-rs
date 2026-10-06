import Mathlib

set_option pp.all true
-- spec: instReprNat : Repr.{0} Nat
def instReprNat : Repr.{0} Nat :=
  Repr.mk.{0} Nat (fun (n : Nat) (x._@.Init.Data.Repr.1733894921._hygCtx._hyg.12 : Nat) => Std.Format.text (Nat.repr n))
