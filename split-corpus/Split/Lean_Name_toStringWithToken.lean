import Mathlib

set_option pp.all true
-- spec: Lean.Name.toStringWithToken : Lean.Name -> (optParam.{1} Bool Bool.true) -> (String -> Bool) -> String
def Lean.Name.toStringWithToken : Lean.Name -> (optParam.{1} Bool Bool.true) -> (String -> Bool) -> String :=
  fun (n : Lean.Name) (escape : Bool) (isToken : String -> Bool) => Lean.Name.toStringWithSep "." (Bool.and (Bool.and (Bool.and escape (Bool.not (Lean.Name.isInaccessibleUserName n))) (Bool.not (Lean.Name.hasMacroScopes n))) (Bool.not (_private.Init.Data.ToString.Name.0.Lean.Name.toStringWithToken.maybePseudoSyntax n))) n isToken
