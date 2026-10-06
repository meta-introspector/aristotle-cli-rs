import Mathlib

set_option pp.all true
-- spec: String.instOrd : Ord.{0} String
def String.instOrd : Ord.{0} String :=
  Ord.mk.{0} String (fun (x : String) (y : String) => compareOfLessAndEq.{0} String x y String.instLT (String.decidableLT x y) instDecidableEqString)
