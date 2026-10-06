import Mathlib

set_option pp.all true
-- spec: Int.mul : ([mdata borrowed:1 Int]) -> ([mdata borrowed:1 Int]) -> Int
def Int.mul : ([mdata borrowed:1 Int]) -> ([mdata borrowed:1 Int]) -> Int :=
  fun (m : Int) (n : Int) => Int.add.match_1.{1} (fun (m._@.Init.Data.Int.Basic.2075127268._hygCtx._hyg.11 : Int) (n._@.Init.Data.Int.Basic.2075127268._hygCtx._hyg.13 : Int) => Int) m n (fun (m : Nat) (n : Nat) => Int.ofNat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m n)) (fun (m : Nat) (n : Nat) => Int.negOfNat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m (Nat.succ n))) (fun (m : Nat) (n : Nat) => Int.negOfNat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Nat.succ m) n)) (fun (m : Nat) (n : Nat) => Int.ofNat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Nat.succ m) (Nat.succ n)))
