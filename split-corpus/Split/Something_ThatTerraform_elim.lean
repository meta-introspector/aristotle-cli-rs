import Mathlib

set_option pp.all true
-- spec: Something.ThatTerraform.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 47) -> (motive Something.ThatTerraform) -> (motive t)
def Something.ThatTerraform.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 47) -> (motive Something.ThatTerraform) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 47) (ThatTerraform : motive Something.ThatTerraform) => Something.ctorElim.{u} motive 47 t (Eq.symm.{1} Nat (Something.ctorIdx t) 47 h) (PULift.up.{u, u} (motive Something.ThatTerraform) ThatTerraform)
