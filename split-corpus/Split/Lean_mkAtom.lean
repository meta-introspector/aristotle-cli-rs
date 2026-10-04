import Mathlib

set_option pp.all true
-- spec: Lean.mkAtom : String -> Lean.Syntax
def Lean.mkAtom : String -> Lean.Syntax :=
  fun (val : String) => Lean.Syntax.atom Lean.SourceInfo.none val
