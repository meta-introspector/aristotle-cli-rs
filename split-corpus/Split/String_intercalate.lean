import Mathlib

set_option pp.all true
-- spec: String.intercalate : String -> (List.{0} String) -> String
def String.intercalate : String -> (List.{0} String) -> String :=
  fun (s : String) (x._@.Init.Data.String.Defs.4247185291._hygCtx._hyg.7 : List.{0} String) => _private.Init.Data.String.Defs.0.String.intercalate.match_1.{1} (fun (x._@.Init.Data.String.Defs.4247185291._hygCtx.7.Init.Data.String.Defs.4247185291._hygCtx._hyg.68 : List.{0} String) => String) x._@.Init.Data.String.Defs.4247185291._hygCtx._hyg.7 (fun (_ : Unit) => "") (fun (a : String) (as : List.{0} String) => _private.Init.Data.String.Defs.0.String.intercalate.go a s as)
