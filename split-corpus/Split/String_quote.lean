import Mathlib

set_option pp.all true
-- spec: String.quote : String -> String
def String.quote : String -> String :=
  fun (s : String) => ite.{1} String (Eq.{1} Bool (String.Internal.isEmpty s) Bool.true) (instDecidableEqBool (String.Internal.isEmpty s) Bool.true) "\"\"" (String.Internal.append (String.Internal.foldl (fun (s : String) (c : Char) => String.Internal.append s (Char.quoteCore c Bool.true)) "\"" s) "\"")
