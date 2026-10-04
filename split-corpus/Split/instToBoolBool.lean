import Mathlib

set_option pp.all true
-- spec: instToBoolBool : ToBool.{0} Bool
def instToBoolBool : ToBool.{0} Bool :=
  ToBool.mk.{0} Bool (fun (b : Bool) => b)
