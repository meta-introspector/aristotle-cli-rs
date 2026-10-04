import Mathlib

set_option pp.all true
-- spec: Int.le : Int -> Int -> Prop
def Int.le : Int -> Int -> Prop :=
  fun (a : Int) (b : Int) => Int.NonNeg (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) b a)
