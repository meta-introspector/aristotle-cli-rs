import Mathlib

set_option pp.all true
-- spec: SProof.casesOn : forall {motive : SProof -> Sort.{u}} (t : SProof), (forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) -> (motive t)
def SProof.casesOn : forall {motive : SProof -> Sort.{u}} (t : SProof), (forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) -> (motive t) :=
  fun {motive : SProof -> Sort.{u}} (t : SProof) (mk : forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) => SProof.rec.{u} motive (fun (steps : List.{0} SRewrite) => mk steps) t
