import Mathlib

set_option pp.all true
-- spec: Something.ThatGithubAction.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 48) -> (motive Something.ThatGithubAction) -> (motive t)
def Something.ThatGithubAction.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 48) -> (motive Something.ThatGithubAction) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 48) (ThatGithubAction : motive Something.ThatGithubAction) => Something.ctorElim.{u} motive 48 t (Eq.symm.{1} Nat (Something.ctorIdx t) 48 h) (PULift.up.{u, u} (motive Something.ThatGithubAction) ThatGithubAction)
