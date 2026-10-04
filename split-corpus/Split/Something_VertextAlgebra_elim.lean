import Mathlib

set_option pp.all true
-- spec: Something.VertextAlgebra.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 27) -> (motive Something.VertextAlgebra) -> (motive t)
def Something.VertextAlgebra.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 27) -> (motive Something.VertextAlgebra) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 27) (VertextAlgebra : motive Something.VertextAlgebra) => Something.ctorElim.{u} motive 27 t (Eq.symm.{1} Nat (Something.ctorIdx t) 27 h) (PULift.up.{u, u} (motive Something.VertextAlgebra) VertextAlgebra)
