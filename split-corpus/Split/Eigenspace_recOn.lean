import Mathlib

set_option pp.all true
-- spec: Eigenspace.recOn : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (motive Eigenspace.earth) -> (motive Eigenspace.spoke) -> (motive Eigenspace.hub) -> (motive Eigenspace.clock) -> (motive t)
def Eigenspace.recOn : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (motive Eigenspace.earth) -> (motive Eigenspace.spoke) -> (motive Eigenspace.hub) -> (motive Eigenspace.clock) -> (motive t) :=
  fun {motive : Eigenspace -> Sort.{u}} (t : Eigenspace) (earth : motive Eigenspace.earth) (spoke : motive Eigenspace.spoke) (hub : motive Eigenspace.hub) (clock : motive Eigenspace.clock) => Eigenspace.rec.{u} motive earth spoke hub clock t
