import Mathlib

set_option pp.all true
-- spec: String.Slice.isEmpty : String.Slice -> Bool
def String.Slice.isEmpty : String.Slice -> Bool :=
  fun (s : String.Slice) => BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (String.Slice.utf8ByteSize s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
