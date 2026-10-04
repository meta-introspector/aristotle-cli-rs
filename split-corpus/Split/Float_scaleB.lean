import Mathlib

-- spec: opaque Float.scaleB : Float -> ([mdata borrowed:1 Int]) -> Float
opaque Float.scaleB : Float -> ([mdata borrowed:1 Int]) -> Float :=
  fun (x : Float) (i : Int) => Inhabited.default.{1} Float instInhabitedFloat
