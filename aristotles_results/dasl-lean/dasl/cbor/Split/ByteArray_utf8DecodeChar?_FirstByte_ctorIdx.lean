import Mathlib

set_option pp.all true
-- spec: ByteArray.utf8DecodeChar?.FirstByte.ctorIdx : ByteArray.utf8DecodeChar?.FirstByte -> Nat
def ByteArray.utf8DecodeChar?.FirstByte.ctorIdx : ByteArray.utf8DecodeChar?.FirstByte -> Nat :=
  fun (x : ByteArray.utf8DecodeChar?.FirstByte) => ByteArray.utf8DecodeChar?.FirstByte.casesOn.{1} (fun (x : ByteArray.utf8DecodeChar?.FirstByte) => Nat) x 0 1 2 3 4
