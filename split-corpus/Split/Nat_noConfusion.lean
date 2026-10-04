import Mathlib

set_option pp.all true
-- spec: Nat.noConfusion : forall {P : Sort.{u}} {t : Nat} {t' : Nat}, (Eq.{1} Nat t t') -> (Nat.noConfusionType.{u} P t t')
def Nat.noConfusion : forall {P : Sort.{u}} {t : Nat} {t' : Nat}, (Eq.{1} Nat t t') -> (Nat.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : Nat} {t' : Nat} (eq : Eq.{1} Nat t t') => Eq.ndrec.{u, 1} Nat t (fun {t' : Nat} => Nat.noConfusionType.{u} P t t') (Nat.casesOn.{u} (fun {t : Nat} => Nat.noConfusionType.{u} P t t) t (fun (k : P) => k) (fun (n : Nat) (k : (Eq.{1} Nat n n) -> P) => k (Eq.refl.{1} Nat n))) t' eq
