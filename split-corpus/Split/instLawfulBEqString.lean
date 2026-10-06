import Mathlib

-- spec: theorem instLawfulBEqString : LawfulBEq.{0} String (instBEqOfDecidableEq.{0} String instDecidableEqString)
theorem instLawfulBEqString : LawfulBEq.{0} String (instBEqOfDecidableEq.{0} String instDecidableEqString) :=
  inferInstance.{0} (LawfulBEq.{0} String (instBEqOfDecidableEq.{0} String instDecidableEqString)) (instLawfulBEq.{0} String instDecidableEqString)
