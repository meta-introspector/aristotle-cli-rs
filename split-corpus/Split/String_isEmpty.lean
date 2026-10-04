import Mathlib

set_option pp.all true
-- spec: String.isEmpty : String -> Bool
def String.isEmpty : String -> Bool :=
  fun (s : String) => BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (String.utf8ByteSize s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
