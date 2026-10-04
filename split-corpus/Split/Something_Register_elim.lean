import Mathlib

set_option pp.all true
-- spec: Something.Register.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 50) -> (motive Something.Register) -> (motive t)
def Something.Register.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 50) -> (motive Something.Register) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 50) (Register : motive Something.Register) => Something.ctorElim.{u} motive 50 t (Eq.symm.{1} Nat (Something.ctorIdx t) 50 h) (PULift.up.{u, u} (motive Something.Register) Register)
