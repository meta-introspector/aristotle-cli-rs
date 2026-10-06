import Mathlib

set_option pp.all true
-- spec: Lean.InternalExceptionId.toString : Lean.InternalExceptionId -> String
def Lean.InternalExceptionId.toString : Lean.InternalExceptionId -> String :=
  fun (id : Lean.InternalExceptionId) => HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString "internal exception #") (ToString.toString.{0} Nat instToStringNat (Lean.InternalExceptionId.idx id))
