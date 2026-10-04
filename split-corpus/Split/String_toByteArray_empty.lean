import Mathlib

-- spec: theorem String.toByteArray_empty : Eq.{1} ByteArray (String.toByteArray "") ByteArray.empty
theorem String.toByteArray_empty : Eq.{1} ByteArray (String.toByteArray "") ByteArray.empty :=
  rfl.{1} ByteArray (String.toByteArray "")
