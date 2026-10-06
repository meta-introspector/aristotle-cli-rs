import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8DecodeChar?.assemble₁ : forall (w : UInt8), (Eq.{1} ByteArray.utf8DecodeChar?.FirstByte (ByteArray.utf8DecodeChar?.parseFirstByte w) ByteArray.utf8DecodeChar?.FirstByte.done) -> (Option.{0} Char)
def ByteArray.utf8DecodeChar?.assemble₁ : forall (w : UInt8), (Eq.{1} ByteArray.utf8DecodeChar?.FirstByte (ByteArray.utf8DecodeChar?.parseFirstByte w) ByteArray.utf8DecodeChar?.FirstByte.done) -> (Option.{0} Char) :=
  fun (w : UInt8) (h : Eq.{1} ByteArray.utf8DecodeChar?.FirstByte (ByteArray.utf8DecodeChar?.parseFirstByte w) ByteArray.utf8DecodeChar?.FirstByte.done) => Option.some.{0} Char (Char.mk (UInt8.toUInt32 w) (ByteArray.utf8DecodeChar?.assemble₁._proof_3 w h))
