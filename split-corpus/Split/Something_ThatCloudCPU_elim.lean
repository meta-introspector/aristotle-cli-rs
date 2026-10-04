import Mathlib

set_option pp.all true
-- spec: Something.ThatCloudCPU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 45) -> (motive Something.ThatCloudCPU) -> (motive t)
def Something.ThatCloudCPU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 45) -> (motive Something.ThatCloudCPU) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 45) (ThatCloudCPU : motive Something.ThatCloudCPU) => Something.ctorElim.{u} motive 45 t (Eq.symm.{1} Nat (Something.ctorIdx t) 45 h) (PULift.up.{u, u} (motive Something.ThatCloudCPU) ThatCloudCPU)
