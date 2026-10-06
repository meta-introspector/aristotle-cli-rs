import Mathlib

set_option pp.all true
-- spec: Something.ThisCPU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 44) -> (motive Something.ThisCPU) -> (motive t)
def Something.ThisCPU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 44) -> (motive Something.ThisCPU) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 44) (ThisCPU : motive Something.ThisCPU) => Something.ctorElim.{u} motive 44 t (Eq.symm.{1} Nat (Something.ctorIdx t) 44 h) (PULift.up.{u, u} (motive Something.ThisCPU) ThisCPU)
