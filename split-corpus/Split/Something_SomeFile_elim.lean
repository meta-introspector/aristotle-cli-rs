import Mathlib

set_option pp.all true
-- spec: Something.SomeFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 58) -> (forall (content : String), motive (Something.SomeFile content)) -> (motive t)
def Something.SomeFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 58) -> (forall (content : String), motive (Something.SomeFile content)) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 58) (SomeFile : forall (content : String), motive (Something.SomeFile content)) => Something.ctorElim.{u} motive 58 t (Eq.symm.{1} Nat (Something.ctorIdx t) 58 h) (PULift.up.{u, u} (forall (content : String), motive (Something.SomeFile content)) SomeFile)
