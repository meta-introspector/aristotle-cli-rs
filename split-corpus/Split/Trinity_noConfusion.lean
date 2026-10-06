import Mathlib

set_option pp.all true
-- spec: Trinity.noConfusion : forall {P : Sort.{u}} {t : Trinity} {t' : Trinity}, (Eq.{1} Trinity t t') -> (Trinity.noConfusionType.{u} P t t')
def Trinity.noConfusion : forall {P : Sort.{u}} {t : Trinity} {t' : Trinity}, (Eq.{1} Trinity t t') -> (Trinity.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : Trinity} {t' : Trinity} (eq : Eq.{1} Trinity t t') => Eq.ndrec.{u, 1} Trinity t (fun {t' : Trinity} => Trinity.noConfusionType.{u} P t t') (Trinity.casesOn.{u} (fun {t : Trinity} => Trinity.noConfusionType.{u} P t t) t (fun (k : P) => k) (fun (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something) (a_2._@._internal._hyg.0 : Something) (k : (Eq.{1} Something a._@._internal._hyg.0 a._@._internal._hyg.0) -> (Eq.{1} Something a_1._@._internal._hyg.0 a_1._@._internal._hyg.0) -> (Eq.{1} Something a_2._@._internal._hyg.0 a_2._@._internal._hyg.0) -> P) => k (Eq.refl.{1} Something a._@._internal._hyg.0) (Eq.refl.{1} Something a_1._@._internal._hyg.0) (Eq.refl.{1} Something a_2._@._internal._hyg.0))) t' eq
