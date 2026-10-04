import Mathlib

set_option pp.all true
-- spec: Something.AristotleByHarmonic.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 64) -> (motive Something.AristotleByHarmonic) -> (motive t)
def Something.AristotleByHarmonic.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 64) -> (motive Something.AristotleByHarmonic) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 64) (AristotleByHarmonic : motive Something.AristotleByHarmonic) => Something.ctorElim.{u} motive 64 t (Eq.symm.{1} Nat (Something.ctorIdx t) 64 h) (PULift.up.{u, u} (motive Something.AristotleByHarmonic) AristotleByHarmonic)
