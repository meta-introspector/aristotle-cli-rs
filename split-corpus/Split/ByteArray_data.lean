import Mathlib

set_option pp.all true
-- spec: ByteArray.data : ByteArray -> (Array.{0} UInt8)
def ByteArray.data : ByteArray -> (Array.{0} UInt8) :=
  fun (self : ByteArray) => self.1
