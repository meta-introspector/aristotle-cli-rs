import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8Decode?.go : forall (b : ByteArray) (i : Nat), (Array.{0} Char) -> (LE.le.{0} Nat instLENat i (ByteArray.size b)) -> (Option.{0} (Array.{0} Char))
def ByteArray.utf8Decode?.go : forall (b : ByteArray) (i : Nat), (Array.{0} Char) -> (LE.le.{0} Nat instLENat i (ByteArray.size b)) -> (Option.{0} (Array.{0} Char)) :=
  fun (b : ByteArray) (i : Nat) (acc : Array.{0} Char) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)) => ByteArray.utf8Decode?.go._unary b (PSigma.mk.{1, 1} Nat (fun (i : Nat) => PSigma.{1, 0} (Array.{0} Char) (fun (acc : Array.{0} Char) => LE.le.{0} Nat instLENat i (ByteArray.size b))) i (PSigma.mk.{1, 0} (Array.{0} Char) (fun (acc : Array.{0} Char) => LE.le.{0} Nat instLENat i (ByteArray.size b)) acc hi))
