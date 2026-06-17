import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.recOn : forall {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode), (motive MicroLean.OwnershipMode.borrowed) -> (motive MicroLean.OwnershipMode.owned) -> (motive t)
def MicroLean.OwnershipMode.recOn : forall {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode), (motive MicroLean.OwnershipMode.borrowed) -> (motive MicroLean.OwnershipMode.owned) -> (motive t) :=
  fun {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode) (borrowed : motive MicroLean.OwnershipMode.borrowed) (owned : motive MicroLean.OwnershipMode.owned) => MicroLean.OwnershipMode.rec.{u} motive borrowed owned t
