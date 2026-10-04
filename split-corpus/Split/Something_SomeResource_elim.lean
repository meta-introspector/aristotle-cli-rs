import Mathlib

set_option pp.all true
-- spec: Something.SomeResource.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 59) -> (forall (res : String), motive (Something.SomeResource res)) -> (motive t)
def Something.SomeResource.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 59) -> (forall (res : String), motive (Something.SomeResource res)) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 59) (SomeResource : forall (res : String), motive (Something.SomeResource res)) => Something.ctorElim.{u} motive 59 t (Eq.symm.{1} Nat (Something.ctorIdx t) 59 h) (PULift.up.{u, u} (forall (res : String), motive (Something.SomeResource res)) SomeResource)
