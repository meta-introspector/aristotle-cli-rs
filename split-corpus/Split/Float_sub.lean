import Mathlib

-- spec: opaque Float.sub : Float -> Float -> Float
opaque Float.sub : Float -> Float -> Float :=
  Classical.ofNonempty.{1} (Float -> Float -> Float) _private.Init.Data.Float.0.Float.add._proof_1
