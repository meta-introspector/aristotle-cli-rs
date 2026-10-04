import Mathlib

set_option pp.all true
-- spec: ByteArray.append : ByteArray -> ByteArray -> ByteArray
def ByteArray.append : ByteArray -> ByteArray -> ByteArray :=
  fun (a : ByteArray) (b : ByteArray) => ByteArray.mk (Array.mk.{0} UInt8 (HAppend.hAppend.{0, 0, 0} (List.{0} UInt8) (List.{0} UInt8) (List.{0} UInt8) (instHAppendOfAppend.{0} (List.{0} UInt8) (List.instAppend.{0} UInt8)) (Array.toList.{0} UInt8 (ByteArray.data a)) (Array.toList.{0} UInt8 (ByteArray.data b))))
