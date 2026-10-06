import Mathlib

set_option pp.all true
-- spec: Something.PyTorch.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 24) -> (motive Something.PyTorch) -> (motive t)
def Something.PyTorch.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 24) -> (motive Something.PyTorch) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 24) (PyTorch : motive Something.PyTorch) => Something.ctorElim.{u} motive 24 t (Eq.symm.{1} Nat (Something.ctorIdx t) 24 h) (PULift.up.{u, u} (motive Something.PyTorch) PyTorch)
