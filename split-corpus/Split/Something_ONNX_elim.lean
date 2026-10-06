import Mathlib

set_option pp.all true
-- spec: Something.ONNX.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 26) -> (motive Something.ONNX) -> (motive t)
def Something.ONNX.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 26) -> (motive Something.ONNX) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 26) (ONNX : motive Something.ONNX) => Something.ctorElim.{u} motive 26 t (Eq.symm.{1} Nat (Something.ctorIdx t) 26 h) (PULift.up.{u, u} (motive Something.ONNX) ONNX)
