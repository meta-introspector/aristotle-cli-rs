import Mathlib

set_option pp.all true
-- spec: SRewrite.ctorIdx : SRewrite -> Nat
def SRewrite.ctorIdx : SRewrite -> Nat :=
  fun (x : SRewrite) => 0
