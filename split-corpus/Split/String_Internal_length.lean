import Mathlib

-- spec: opaque String.Internal.length : ([mdata borrowed:1 String]) -> Nat
opaque String.Internal.length : ([mdata borrowed:1 String]) -> Nat :=
  Inhabited.default.{1} (([mdata borrowed:1 String]) -> Nat) (Pi.instInhabited.{1, 1} ([mdata borrowed:1 String]) (fun (a._@._internal._hyg.0 : [mdata borrowed:1 String]) => Nat) (fun (a : [mdata borrowed:1 String]) => instInhabitedNat))
