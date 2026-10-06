import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.BoundingBox.recOn : forall {motive : AristotleWeaver.Core.BoundingBox -> Sort.{u}} (t : AristotleWeaver.Core.BoundingBox), (forall (x : Float) (y : Float) (w : Float) (h : Float), motive (AristotleWeaver.Core.BoundingBox.mk x y w h)) -> (motive t)
def AristotleWeaver.Core.BoundingBox.recOn : forall {motive : AristotleWeaver.Core.BoundingBox -> Sort.{u}} (t : AristotleWeaver.Core.BoundingBox), (forall (x : Float) (y : Float) (w : Float) (h : Float), motive (AristotleWeaver.Core.BoundingBox.mk x y w h)) -> (motive t) :=
  fun {motive : AristotleWeaver.Core.BoundingBox -> Sort.{u}} (t : AristotleWeaver.Core.BoundingBox) (mk : forall (x : Float) (y : Float) (w : Float) (h : Float), motive (AristotleWeaver.Core.BoundingBox.mk x y w h)) => AristotleWeaver.Core.BoundingBox.rec.{u} motive mk t
