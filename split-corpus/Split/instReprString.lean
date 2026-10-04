import Mathlib

set_option pp.all true
-- spec: instReprString : Repr.{0} String
def instReprString : Repr.{0} String :=
  Repr.mk.{0} String (fun (s : String) (x._@.Init.Data.Repr.320794042._hygCtx._hyg.12 : Nat) => Std.Format.text (String.quote s))
