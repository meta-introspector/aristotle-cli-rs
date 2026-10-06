import Mathlib

set_option pp.all true
-- spec: Int.decLt : forall (a : [mdata borrowed:1 Int]) (b : [mdata borrowed:1 Int]), Decidable (LT.lt.{0} ([mdata borrowed:1 Int]) Int.instLTInt a b)
def Int.decLt : forall (a : [mdata borrowed:1 Int]) (b : [mdata borrowed:1 Int]), Decidable (LT.lt.{0} ([mdata borrowed:1 Int]) Int.instLTInt a b) :=
  fun (a : Int) (b : Int) => Int.decNonneg (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) b (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (OfNat.ofNat.{0} Int 1 (instOfNat 1))))
