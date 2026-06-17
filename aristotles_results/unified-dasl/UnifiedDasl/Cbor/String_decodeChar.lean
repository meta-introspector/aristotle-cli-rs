import Mathlib

set_option pp.all true
-- spec: String.decodeChar : forall (s : [mdata borrowed:1 String]) (byteIdx : [mdata borrowed:1 Nat]), (Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? (String.toByteArray s) byteIdx)) Bool.true) -> Char
def String.decodeChar : forall (s : [mdata borrowed:1 String]) (byteIdx : [mdata borrowed:1 Nat]), (Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? (String.toByteArray s) byteIdx)) Bool.true) -> Char :=
  fun (s : String) (byteIdx : Nat) (h : Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? (String.toByteArray s) byteIdx)) Bool.true) => ByteArray.utf8DecodeChar (String.toByteArray s) byteIdx h
