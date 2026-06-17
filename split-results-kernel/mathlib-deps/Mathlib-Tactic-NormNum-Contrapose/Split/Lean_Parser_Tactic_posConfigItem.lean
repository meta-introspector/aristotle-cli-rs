import Mathlib

set_option pp.all true
-- spec: Lean.Parser.Tactic.posConfigItem : Lean.ParserDescr
def Lean.Parser.Tactic.posConfigItem : Lean.ParserDescr :=
  Lean.ParserDescr.nodeWithAntiquot "posConfigItem" (Lean.Name.mkStr4 "Lean" "Parser" "Tactic" "posConfigItem") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "andthen") (Lean.ParserDescr.symbol " +") (Lean.ParserDescr.const (Lean.Name.mkStr1 "noWs"))) (Lean.ParserDescr.const (Lean.Name.mkStr1 "ident")))
