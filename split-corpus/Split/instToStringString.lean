import Mathlib

set_option pp.all true
-- spec: instToStringString : ToString.{0} String
def instToStringString : ToString.{0} String :=
  ToString.mk.{0} String (fun (s : String) => s)
