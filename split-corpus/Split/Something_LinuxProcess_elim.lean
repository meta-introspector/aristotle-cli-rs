import Mathlib

set_option pp.all true
-- spec: Something.LinuxProcess.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 43) -> (motive Something.LinuxProcess) -> (motive t)
def Something.LinuxProcess.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 43) -> (motive Something.LinuxProcess) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 43) (LinuxProcess : motive Something.LinuxProcess) => Something.ctorElim.{u} motive 43 t (Eq.symm.{1} Nat (Something.ctorIdx t) 43 h) (PULift.up.{u, u} (motive Something.LinuxProcess) LinuxProcess)
