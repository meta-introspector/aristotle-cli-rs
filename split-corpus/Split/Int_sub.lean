import Mathlib

set_option pp.all true
-- spec: Int.sub : ([mdata borrowed:1 Int]) -> ([mdata borrowed:1 Int]) -> Int
def Int.sub : ([mdata borrowed:1 Int]) -> ([mdata borrowed:1 Int]) -> Int :=
  fun (m : Int) (n : Int) => HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) m (Neg.neg.{0} Int Int.instNegInt n)
