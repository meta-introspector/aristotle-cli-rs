import Mathlib

set_option pp.all true
-- spec: Something.LLVMAst.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 41) -> (motive Something.LLVMAst) -> (motive t)
def Something.LLVMAst.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 41) -> (motive Something.LLVMAst) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 41) (LLVMAst : motive Something.LLVMAst) => Something.ctorElim.{u} motive 41 t (Eq.symm.{1} Nat (Something.ctorIdx t) 41 h) (PULift.up.{u, u} (motive Something.LLVMAst) LLVMAst)
