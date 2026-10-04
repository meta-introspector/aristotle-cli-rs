import Mathlib

set_option pp.all true
-- spec: Lean.Name.toString : Lean.Name -> (optParam.{1} Bool Bool.true) -> String
def Lean.Name.toString : Lean.Name -> (optParam.{1} Bool Bool.true) -> String :=
  fun (n : Lean.Name) (escape : Bool) => Lean.Name.toStringWithToken n escape (fun (x._@.Init.Data.ToString.Name.2738761429._hygCtx._hyg.14 : String) => Bool.false)
