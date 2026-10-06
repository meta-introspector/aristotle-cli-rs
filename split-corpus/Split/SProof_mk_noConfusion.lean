import Mathlib

set_option pp.all true
-- spec: SProof.mk.noConfusion : forall {P : Sort.{u}} {steps : List.{0} SRewrite} {steps' : List.{0} SRewrite}, (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps')) -> ((Eq.{1} (List.{0} SRewrite) steps steps') -> P) -> P
def SProof.mk.noConfusion : forall {P : Sort.{u}} {steps : List.{0} SRewrite} {steps' : List.{0} SRewrite}, (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps')) -> ((Eq.{1} (List.{0} SRewrite) steps steps') -> P) -> P :=
  fun {P : Sort.{u}} {steps : List.{0} SRewrite} {steps' : List.{0} SRewrite} (eq : Eq.{1} SProof (SProof.mk steps) (SProof.mk steps')) (k : (Eq.{1} (List.{0} SRewrite) steps steps') -> P) => id.{u} P (SProof.noConfusion.{u} P (SProof.mk steps) (SProof.mk steps') eq k)
