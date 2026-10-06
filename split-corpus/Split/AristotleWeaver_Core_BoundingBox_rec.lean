import Mathlib

-- spec: recursor AristotleWeaver.Core.BoundingBox.rec : forall {motive : AristotleWeaver.Core.BoundingBox -> Sort.{u}}, (forall (x : Float) (y : Float) (w : Float) (h : Float), motive (AristotleWeaver.Core.BoundingBox.mk x y w h)) -> (forall (t : AristotleWeaver.Core.BoundingBox), motive t)
