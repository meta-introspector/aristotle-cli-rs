import Mathlib

set_option pp.all true
-- spec: Eigenspace.clock.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 3) -> (motive Eigenspace.clock) -> (motive t)
def Eigenspace.clock.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 3) -> (motive Eigenspace.clock) -> (motive t) :=
  fun {motive : Eigenspace -> Sort.{u}} (t : Eigenspace) (h : Eq.{1} Nat (Eigenspace.ctorIdx t) 3) (clock : motive Eigenspace.clock) => Eigenspace.ctorElim.{u} motive 3 t (Eq.symm.{1} Nat (Eigenspace.ctorIdx t) 3 h) (PULift.up.{u, u} (motive Eigenspace.clock) clock)
