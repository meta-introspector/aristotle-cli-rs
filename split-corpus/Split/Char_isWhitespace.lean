import Mathlib

set_option pp.all true
-- spec: Char.isWhitespace : Char -> Bool
def Char.isWhitespace : Char -> Bool :=
  fun (c : Char) => Bool.or (Bool.or (Bool.or (Decidable.decide (Eq.{1} Char c (Char.ofNat 32)) (instDecidableEqChar c (Char.ofNat 32))) (Decidable.decide (Eq.{1} Char c (Char.ofNat 9)) (instDecidableEqChar c (Char.ofNat 9)))) (Decidable.decide (Eq.{1} Char c (Char.ofNat 13)) (instDecidableEqChar c (Char.ofNat 13)))) (Decidable.decide (Eq.{1} Char c (Char.ofNat 10)) (instDecidableEqChar c (Char.ofNat 10)))
