import Mathlib

set_option pp.all true
-- spec: Something.OrderBookState.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 55) -> (motive Something.OrderBookState) -> (motive t)
def Something.OrderBookState.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 55) -> (motive Something.OrderBookState) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 55) (OrderBookState : motive Something.OrderBookState) => Something.ctorElim.{u} motive 55 t (Eq.symm.{1} Nat (Something.ctorIdx t) 55 h) (PULift.up.{u, u} (motive Something.OrderBookState) OrderBookState)
