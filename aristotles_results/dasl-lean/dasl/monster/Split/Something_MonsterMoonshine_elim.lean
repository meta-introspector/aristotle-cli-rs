import Mathlib

set_option pp.all true
-- spec: Something.MonsterMoonshine.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 28) -> (motive Something.MonsterMoonshine) -> (motive t)
def Something.MonsterMoonshine.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 28) -> (motive Something.MonsterMoonshine) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 28) (MonsterMoonshine : motive Something.MonsterMoonshine) => Something.ctorElim.{u} motive 28 t (Eq.symm.{1} Nat (Something.ctorIdx t) 28 h) (PULift.up.{u, u} (motive Something.MonsterMoonshine) MonsterMoonshine)
