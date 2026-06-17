import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.recOn : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (motive MicroLean.MutMode.borrowed) -> (motive MicroLean.MutMode.mutBorrow) -> (motive MicroLean.MutMode.owned) -> (motive t)
def MicroLean.MutMode.recOn : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (motive MicroLean.MutMode.borrowed) -> (motive MicroLean.MutMode.mutBorrow) -> (motive MicroLean.MutMode.owned) -> (motive t) :=
  fun {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode) (borrowed : motive MicroLean.MutMode.borrowed) (mutBorrow : motive MicroLean.MutMode.mutBorrow) (owned : motive MicroLean.MutMode.owned) => MicroLean.MutMode.rec.{u} motive borrowed mutBorrow owned t
