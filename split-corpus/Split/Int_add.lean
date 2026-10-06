import Mathlib

set_option pp.all true
-- spec: Int.add : ([mdata borrowed:1 Int]) -> ([mdata borrowed:1 Int]) -> Int
def Int.add : ([mdata borrowed:1 Int]) -> ([mdata borrowed:1 Int]) -> Int :=
  fun (m : Int) (n : Int) => Int.add.match_1.{1} (fun (m._@.Init.Data.Int.Basic.2314059840._hygCtx._hyg.11 : Int) (n._@.Init.Data.Int.Basic.2314059840._hygCtx._hyg.13 : Int) => Int) m n (fun (m : Nat) (n : Nat) => Int.ofNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n)) (fun (m : Nat) (n : Nat) => Int.subNatNat m (Nat.succ n)) (fun (m : Nat) (n : Nat) => Int.subNatNat n (Nat.succ m)) (fun (m : Nat) (n : Nat) => Int.negSucc (Nat.succ (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n)))
