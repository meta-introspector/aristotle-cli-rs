import Mathlib

set_option pp.all true
-- spec: List.range : Nat -> (List.{0} Nat)
def List.range : Nat -> (List.{0} Nat) :=
  fun (n : Nat) => List.range.loop n (List.nil.{0} Nat)
