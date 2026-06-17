import Mathlib

set_option pp.all true
-- spec: MicroLean.exportFFI : Lean.ParserDescr
def MicroLean.exportFFI : Lean.ParserDescr :=
  Lean.ParserDescr.node (Lean.Name.mkStr2 "MicroLean" "exportFFI") (OfNat.ofNat.{0} Nat 1022 (instOfNatNat 1022)) (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.symbol "meta_lean_export ") (Lean.ParserDescr.const (Lean.Name.mkStr1 "ident"))) (Lean.ParserDescr.symbol " : ")) (Lean.ParserDescr.cat (Lean.Name.mkStr1 "term") (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))
