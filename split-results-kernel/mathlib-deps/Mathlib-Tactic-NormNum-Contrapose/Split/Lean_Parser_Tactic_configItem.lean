import Mathlib

set_option pp.all true
-- spec: Lean.Parser.Tactic.configItem : Lean.ParserDescr
def Lean.Parser.Tactic.configItem : Lean.ParserDescr :=
  Lean.ParserDescr.nodeWithAntiquot "configItem" (Lean.Name.mkStr4 "Lean" "Parser" "Tactic" "configItem") (Lean.ParserDescr.binary (Lean.Name.mkStr1 "orelse") Lean.Parser.Tactic.posConfigItem (Lean.ParserDescr.binary (Lean.Name.mkStr1 "orelse") Lean.Parser.Tactic.negConfigItem Lean.Parser.Tactic.valConfigItem))
