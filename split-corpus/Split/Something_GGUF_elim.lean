import Mathlib

set_option pp.all true
-- spec: Something.GGUF.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 25) -> (motive Something.GGUF) -> (motive t)
def Something.GGUF.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 25) -> (motive Something.GGUF) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 25) (GGUF : motive Something.GGUF) => Something.ctorElim.{u} motive 25 t (Eq.symm.{1} Nat (Something.ctorIdx t) 25 h) (PULift.up.{u, u} (motive Something.GGUF) GGUF)
