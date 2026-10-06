import Mathlib

set_option pp.all true
-- spec: Something.SomeAiAgent.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 9) -> (motive Something.SomeAiAgent) -> (motive t)
def Something.SomeAiAgent.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 9) -> (motive Something.SomeAiAgent) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 9) (SomeAiAgent : motive Something.SomeAiAgent) => Something.ctorElim.{u} motive 9 t (Eq.symm.{1} Nat (Something.ctorIdx t) 9 h) (PULift.up.{u, u} (motive Something.SomeAiAgent) SomeAiAgent)
