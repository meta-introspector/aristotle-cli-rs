import Mathlib

set_option pp.all true
-- spec: Int.neg : ([mdata borrowed:1 Int]) -> Int
def Int.neg : ([mdata borrowed:1 Int]) -> Int :=
  fun (n : Int) => Int.neg.match_1.{1} (fun (n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8 : Int) => Int) n (fun (n : Nat) => Int.negOfNat n) (fun (n : Nat) => Nat.cast.{0} Int instNatCastInt (Nat.succ n))
