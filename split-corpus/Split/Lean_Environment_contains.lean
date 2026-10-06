import Mathlib

set_option pp.all true
-- spec: Lean.Environment.contains : Lean.Environment -> Lean.Name -> (optParam.{1} Bool Bool.true) -> Bool
def Lean.Environment.contains : Lean.Environment -> Lean.Name -> (optParam.{1} Bool Bool.true) -> Bool :=
  fun (env : Lean.Environment) (n : Lean.Name) (skipRealize : Bool) => Option.isSome.{0} Lean.AsyncConstantInfo (Lean.Environment.findAsync? env n skipRealize)
