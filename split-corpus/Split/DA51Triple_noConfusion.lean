import Mathlib

set_option pp.all true
-- spec: DA51Triple.noConfusion : forall {P : Sort.{u}} {t : DA51Triple} {t' : DA51Triple}, (Eq.{1} DA51Triple t t') -> (DA51Triple.noConfusionType.{u} P t t')
def DA51Triple.noConfusion : forall {P : Sort.{u}} {t : DA51Triple} {t' : DA51Triple}, (Eq.{1} DA51Triple t t') -> (DA51Triple.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : DA51Triple} {t' : DA51Triple} (eq : Eq.{1} DA51Triple t t') => Eq.ndrec.{u, 1} DA51Triple t (fun {t' : DA51Triple} => DA51Triple.noConfusionType.{u} P t t') (DA51Triple.casesOn.{u} (fun {t : DA51Triple} => DA51Triple.noConfusionType.{u} P t t) t (fun (source : DA51Address) (target : DA51Address) (relation_op : DA51Address) (k : (Eq.{1} DA51Address source source) -> (Eq.{1} DA51Address target target) -> (Eq.{1} DA51Address relation_op relation_op) -> P) => k (Eq.refl.{1} DA51Address source) (Eq.refl.{1} DA51Address target) (Eq.refl.{1} DA51Address relation_op))) t' eq
