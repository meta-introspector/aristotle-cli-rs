import Mathlib

-- spec: theorem List.toByteArray_nil : Eq.{1} ByteArray (List.toByteArray (List.nil.{0} UInt8)) ByteArray.empty
theorem List.toByteArray_nil : Eq.{1} ByteArray (List.toByteArray (List.nil.{0} UInt8)) ByteArray.empty :=
  rfl.{1} ByteArray (List.toByteArray (List.nil.{0} UInt8))
