import Mathlib

set_option pp.all true
-- spec: Char.instDecidableLt : forall (a : Char) (b : Char), Decidable (LT.lt.{0} Char Char.instLT a b)
def Char.instDecidableLt : forall (a : Char) (b : Char), Decidable (LT.lt.{0} Char Char.instLT a b) :=
  fun (a : Char) (b : Char) => UInt32.decLt (Char.val a) (Char.val b)
