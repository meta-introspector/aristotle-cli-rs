import Mathlib

set_option pp.all true
-- spec: Something.SomeMagic.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 61) -> (motive Something.SomeMagic) -> (motive t)
def Something.SomeMagic.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 61) -> (motive Something.SomeMagic) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 61) (SomeMagic : motive Something.SomeMagic) => Something.ctorElim.{u} motive 61 t (Eq.symm.{1} Nat (Something.ctorIdx t) 61 h) (PULift.up.{u, u} (motive Something.SomeMagic) SomeMagic)
