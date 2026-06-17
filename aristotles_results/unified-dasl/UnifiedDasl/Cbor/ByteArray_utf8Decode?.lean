import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8Decode? : ByteArray -> (Option.{0} (Array.{0} Char))
def ByteArray.utf8Decode? : ByteArray -> (Option.{0} (Array.{0} Char)) :=
  fun (b : ByteArray) => ByteArray.utf8Decode?.go b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (List.toArray.{0} Char (List.nil.{0} Char)) (ByteArray.utf8Decode?._proof_1 b)
