import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8DecodeChar : forall (bytes : ByteArray) (i : Nat), (Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? bytes i)) Bool.true) -> Char
def ByteArray.utf8DecodeChar : forall (bytes : ByteArray) (i : Nat), (Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? bytes i)) Bool.true) -> Char :=
  fun (bytes : ByteArray) (i : Nat) (h : Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? bytes i)) Bool.true) => Option.get.{0} Char (ByteArray.utf8DecodeChar? bytes i) h
