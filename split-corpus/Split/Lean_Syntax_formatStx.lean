import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.formatStx : Lean.Syntax -> (optParam.{1} (Option.{0} Nat) (Option.none.{0} Nat)) -> (optParam.{1} Bool Bool.false) -> Std.Format
def Lean.Syntax.formatStx : Lean.Syntax -> (optParam.{1} (Option.{0} Nat) (Option.none.{0} Nat)) -> (optParam.{1} Bool Bool.false) -> Std.Format :=
  fun (stx : Lean.Syntax) (maxDepth : Option.{0} Nat) (showInfo : Bool) => Lean.Syntax.formatStxAux maxDepth showInfo (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) stx
