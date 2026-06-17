import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.SimpleExpr.brecOn : forall {motive : AristotleWeaver.Core.SimpleExpr -> Sort.{u}} (t : AristotleWeaver.Core.SimpleExpr), (forall (t : AristotleWeaver.Core.SimpleExpr), (AristotleWeaver.Core.SimpleExpr.below.{u} motive t) -> (motive t)) -> (motive t)
def AristotleWeaver.Core.SimpleExpr.brecOn : forall {motive : AristotleWeaver.Core.SimpleExpr -> Sort.{u}} (t : AristotleWeaver.Core.SimpleExpr), (forall (t : AristotleWeaver.Core.SimpleExpr), (AristotleWeaver.Core.SimpleExpr.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : AristotleWeaver.Core.SimpleExpr -> Sort.{u}} (t : AristotleWeaver.Core.SimpleExpr) (F_1 : forall (t : AristotleWeaver.Core.SimpleExpr), (AristotleWeaver.Core.SimpleExpr.below.{u} motive t) -> (motive t)) => (AristotleWeaver.Core.SimpleExpr.brecOn.go.{u} motive t F_1).1
