import Mathlib

set_option pp.all true
-- spec: Int.subNatNat : Nat -> Nat -> Int
def Int.subNatNat : Nat -> Nat -> Int :=
  fun (m : Nat) (n : Nat) => Int.negOfNat.match_1.{1} (fun (x._@.Init.Data.Int.Basic.3995368154._hygCtx._hyg.19 : Nat) => Int) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) (fun (_ : Unit) => Int.ofNat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m n)) (fun (k : Nat) => Int.negSucc k)
