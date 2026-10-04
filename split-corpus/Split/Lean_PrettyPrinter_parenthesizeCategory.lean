import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.parenthesizeCategory : Lean.Name -> Lean.Syntax -> (Lean.Core.CoreM Lean.Syntax)
def Lean.PrettyPrinter.parenthesizeCategory : Lean.Name -> Lean.Syntax -> (Lean.Core.CoreM Lean.Syntax) :=
  fun (cat : Lean.Name) (stx : Lean.Syntax) => Lean.PrettyPrinter.parenthesize (Lean.PrettyPrinter.Parenthesizer.categoryParser.parenthesizer cat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) stx
