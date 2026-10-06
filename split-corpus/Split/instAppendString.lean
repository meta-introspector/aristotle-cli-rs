import Mathlib

set_option pp.all true
-- spec: instAppendString : Append.{0} String
def instAppendString : Append.{0} String :=
  Append.mk.{0} String (fun (s : String) (t : String) => String.append s t)
