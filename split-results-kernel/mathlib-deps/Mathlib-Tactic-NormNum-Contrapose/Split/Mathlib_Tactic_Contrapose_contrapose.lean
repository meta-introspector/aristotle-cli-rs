import Mathlib

set_option pp.all true
-- spec: Mathlib.Tactic.Contrapose.contrapose : Lean.ParserDescr
def Mathlib.Tactic.Contrapose.contrapose : Lean.ParserDescr :=
  Lean.ParserDescr.node (Lean.Name.mkStr4 "Mathlib" "Tactic" "Contrapose" "contrapose") (OfNat.ofNat.{0} Nat 1022 (instOfNatNat 1022)) (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.nonReservedSymbol "contrapose" Bool.false) (Lean.ParserDescr.unary (Lean.Name.mkStr1 "optional") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.const (Lean.Name.mkStr1 "ppSpace")) (Lean.ParserDescr.const (Lean.Name.mkStr1 "colGt"))) (Lean.ParserDescr.const (Lean.Name.mkStr1 "ident"))) (Lean.ParserDescr.unary (Lean.Name.mkStr1 "optional") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.symbol " with ") (Lean.ParserDescr.const (Lean.Name.mkStr1 "ident")))))))
