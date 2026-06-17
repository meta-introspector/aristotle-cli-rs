import Mathlib

set_option pp.all true
-- spec: SProof.noConfusion : forall {P : Sort.{u}} {t : SProof} {t' : SProof}, (Eq.{1} SProof t t') -> (SProof.noConfusionType.{u} P t t')
def SProof.noConfusion : forall {P : Sort.{u}} {t : SProof} {t' : SProof}, (Eq.{1} SProof t t') -> (SProof.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : SProof} {t' : SProof} (eq : Eq.{1} SProof t t') => Eq.ndrec.{u, 1} SProof t (fun {t' : SProof} => SProof.noConfusionType.{u} P t t') (SProof.casesOn.{u} (fun {t : SProof} => SProof.noConfusionType.{u} P t t) t (fun (steps : List.{0} SRewrite) (k : (Eq.{1} (List.{0} SRewrite) steps steps) -> P) => k (Eq.refl.{1} (List.{0} SRewrite) steps))) t' eq
