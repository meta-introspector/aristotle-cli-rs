import Mathlib

set_option pp.all true
-- spec: Trinity.Three.elim : forall {motive : Trinity -> Sort.{u}} (t : Trinity), (Eq.{1} Nat (Trinity.ctorIdx t) 0) -> (motive Trinity.Three) -> (motive t)
def Trinity.Three.elim : forall {motive : Trinity -> Sort.{u}} (t : Trinity), (Eq.{1} Nat (Trinity.ctorIdx t) 0) -> (motive Trinity.Three) -> (motive t) :=
  fun {motive : Trinity -> Sort.{u}} (t : Trinity) (h : Eq.{1} Nat (Trinity.ctorIdx t) 0) (Three : motive Trinity.Three) => Trinity.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (Trinity.ctorIdx t) 0 h) (PULift.up.{u, u} (motive Trinity.Three) Three)
