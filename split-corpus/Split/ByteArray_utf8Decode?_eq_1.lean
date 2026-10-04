import Mathlib

-- spec: theorem ByteArray.utf8Decode?.eq_1 : forall (b : ByteArray), Eq.{1} (Option.{0} (Array.{0} Char)) (ByteArray.utf8Decode? b) (ByteArray.utf8Decode?.go b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (List.toArray.{0} Char (List.nil.{0} Char)) (ByteArray.utf8Decode?._proof_1 b))
theorem ByteArray.utf8Decode?.eq_1 : forall (b : ByteArray), Eq.{1} (Option.{0} (Array.{0} Char)) (ByteArray.utf8Decode? b) (ByteArray.utf8Decode?.go b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (List.toArray.{0} Char (List.nil.{0} Char)) (ByteArray.utf8Decode?._proof_1 b)) :=
  fun (b : ByteArray) => Eq.refl.{1} (Option.{0} (Array.{0} Char)) (ByteArray.utf8Decode? b)
