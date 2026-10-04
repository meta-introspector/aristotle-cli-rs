import Mathlib

set_option pp.all true
-- spec: Lean.unknownIdentifierMessageTag : Lean.Name
def Lean.unknownIdentifierMessageTag : Lean.Name :=
  Lean.kindOfErrorName (Lean.Name.mkStr2 "lean" "unknownIdentifier")
