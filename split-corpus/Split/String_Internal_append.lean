import Mathlib

-- spec: opaque String.Internal.append : String -> ([mdata borrowed:1 String]) -> String
opaque String.Internal.append : String -> ([mdata borrowed:1 String]) -> String :=
  Inhabited.default.{1} (String -> ([mdata borrowed:1 String]) -> String) (Pi.instInhabited.{1, 1} String (fun (a._@._internal._hyg.0 : String) => ([mdata borrowed:1 String]) -> String) (fun (a : String) => Pi.instInhabited.{1, 1} ([mdata borrowed:1 String]) (fun (a._@._internal._hyg.0 : [mdata borrowed:1 String]) => String) (fun (a : [mdata borrowed:1 String]) => String.instInhabited)))
