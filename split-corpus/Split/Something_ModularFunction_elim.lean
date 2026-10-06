import Mathlib

set_option pp.all true
-- spec: Something.ModularFunction.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 29) -> (motive Something.ModularFunction) -> (motive t)
def Something.ModularFunction.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 29) -> (motive Something.ModularFunction) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 29) (ModularFunction : motive Something.ModularFunction) => Something.ctorElim.{u} motive 29 t (Eq.symm.{1} Nat (Something.ctorIdx t) 29 h) (PULift.up.{u, u} (motive Something.ModularFunction) ModularFunction)
