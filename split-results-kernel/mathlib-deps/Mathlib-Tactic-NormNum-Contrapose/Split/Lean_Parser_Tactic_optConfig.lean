import Mathlib

set_option pp.all true
-- spec: Lean.Parser.Tactic.optConfig : Lean.ParserDescr
def Lean.Parser.Tactic.optConfig : Lean.ParserDescr :=
  Lean.ParserDescr.nodeWithAntiquot "optConfig" (Lean.Name.mkStr4 "Lean" "Parser" "Tactic" "optConfig") (Lean.ParserDescr.unary (Lean.Name.mkStr1 "many") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.const (Lean.Name.mkStr1 "colGt")) Lean.Parser.Tactic.configItem))
