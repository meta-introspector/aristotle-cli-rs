import Mathlib

set_option pp.all true
-- spec: Nat.testBit : Nat -> Nat -> Bool
def Nat.testBit : Nat -> Nat -> Bool :=
  fun (m : Nat) (n : Nat) => bne.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (HAnd.hAnd.{0, 0, 0} Nat Nat Nat (instHAndOfAndOp.{0} Nat Nat.instAndOp) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) m n)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
