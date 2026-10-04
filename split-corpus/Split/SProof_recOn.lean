import Mathlib

set_option pp.all true
-- spec: SProof.recOn : forall {motive : SProof -> Sort.{u}} (t : SProof), (forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) -> (motive t)
def SProof.recOn : forall {motive : SProof -> Sort.{u}} (t : SProof), (forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) -> (motive t) :=
  fun {motive : SProof -> Sort.{u}} (t : SProof) (mk : forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) => SProof.rec.{u} motive mk t
