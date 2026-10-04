import Mathlib

-- spec: opaque mixHash : UInt64 -> UInt64 -> UInt64
opaque mixHash : UInt64 -> UInt64 -> UInt64 :=
  fun (u₁ : UInt64) (u₂ : UInt64) => Inhabited.default.{1} UInt64 instInhabitedUInt64
