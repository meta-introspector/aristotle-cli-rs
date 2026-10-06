import Mathlib

-- spec: opaque UInt64.toFloat : UInt64 -> Float
opaque UInt64.toFloat : UInt64 -> Float :=
  fun (n : UInt64) => Classical.ofNonempty.{1} Float instNonemptyFloat
