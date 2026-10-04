import Mathlib

set_option pp.all true
-- spec: Something.SomeUrl.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 57) -> (forall (url : String), motive (Something.SomeUrl url)) -> (motive t)
def Something.SomeUrl.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 57) -> (forall (url : String), motive (Something.SomeUrl url)) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 57) (SomeUrl : forall (url : String), motive (Something.SomeUrl url)) => Something.ctorElim.{u} motive 57 t (Eq.symm.{1} Nat (Something.ctorIdx t) 57 h) (PULift.up.{u, u} (forall (url : String), motive (Something.SomeUrl url)) SomeUrl)
