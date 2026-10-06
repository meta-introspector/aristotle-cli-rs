import Mathlib

set_option pp.all true
-- spec: Int.lt : Int -> Int -> Prop
def Int.lt : Int -> Int -> Prop :=
  fun (a : Int) (b : Int) => LE.le.{0} Int Int.instLEInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (OfNat.ofNat.{0} Int 1 (instOfNat 1))) b
