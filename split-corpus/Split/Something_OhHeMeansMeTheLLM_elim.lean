import Mathlib

set_option pp.all true
-- spec: Something.OhHeMeansMeTheLLM.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 16) -> (motive Something.OhHeMeansMeTheLLM) -> (motive t)
def Something.OhHeMeansMeTheLLM.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 16) -> (motive Something.OhHeMeansMeTheLLM) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 16) (OhHeMeansMeTheLLM : motive Something.OhHeMeansMeTheLLM) => Something.ctorElim.{u} motive 16 t (Eq.symm.{1} Nat (Something.ctorIdx t) 16 h) (PULift.up.{u, u} (motive Something.OhHeMeansMeTheLLM) OhHeMeansMeTheLLM)
