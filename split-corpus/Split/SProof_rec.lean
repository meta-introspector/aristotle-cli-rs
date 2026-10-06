import Mathlib

-- spec: recursor SProof.rec : forall {motive : SProof -> Sort.{u}}, (forall (steps : List.{0} SRewrite), motive (SProof.mk steps)) -> (forall (t : SProof), motive t)
