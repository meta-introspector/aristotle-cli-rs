import Mathlib

set_option pp.all true
-- spec: SRewrite.noConfusion : forall {P : Sort.{u}} {t : SRewrite} {t' : SRewrite}, (Eq.{1} SRewrite t t') -> (SRewrite.noConfusionType.{u} P t t')
def SRewrite.noConfusion : forall {P : Sort.{u}} {t : SRewrite} {t' : SRewrite}, (Eq.{1} SRewrite t t') -> (SRewrite.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : SRewrite} {t' : SRewrite} (eq : Eq.{1} SRewrite t t') => Eq.ndrec.{u, 1} SRewrite t (fun {t' : SRewrite} => SRewrite.noConfusionType.{u} P t t') (SRewrite.casesOn.{u} (fun {t : SRewrite} => SRewrite.noConfusionType.{u} P t t) t (fun (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something) (k : (Eq.{1} Something fromThing fromThing) -> (Eq.{1} Something how how) -> (Eq.{1} (Option.{0} Something) via via) -> (Eq.{1} Something toThing toThing) -> P) => k (Eq.refl.{1} Something fromThing) (Eq.refl.{1} Something how) (Eq.refl.{1} (Option.{0} Something) via) (Eq.refl.{1} Something toThing))) t' eq
