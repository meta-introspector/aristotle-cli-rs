import Mathlib

-- spec: opaque String.hash : ([mdata borrowed:1 String]) -> UInt64
opaque String.hash : ([mdata borrowed:1 String]) -> UInt64 :=
  fun (s : String) => Inhabited.default.{1} UInt64 instInhabitedUInt64
