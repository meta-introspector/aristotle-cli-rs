import Mathlib

set_option pp.all true
-- spec: Bool.noConfusion : forall {P : Sort.{u}} {t : Bool} {t' : Bool}, (Eq.{1} Bool t t') -> (Bool.noConfusionType.{u} P t t')
def Bool.noConfusion : forall {P : Sort.{u}} {t : Bool} {t' : Bool}, (Eq.{1} Bool t t') -> (Bool.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : Bool} {t' : Bool} (eq : Eq.{1} Bool t t') => Eq.ndrec.{u, 1} Bool t (fun {t' : Bool} => Bool.noConfusionType.{u} P t t') (Bool.casesOn.{u} (fun {t : Bool} => Bool.noConfusionType.{u} P t t) t (fun (k : P) => k) (fun (k : P) => k)) t' eq
