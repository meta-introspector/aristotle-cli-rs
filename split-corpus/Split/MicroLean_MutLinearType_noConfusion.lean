import Mathlib

set_option pp.all true
-- spec: MicroLean.MutLinearType.noConfusion : forall {P : Sort.{u}} {t : MicroLean.MutLinearType} {t' : MicroLean.MutLinearType}, (Eq.{1} MicroLean.MutLinearType t t') -> (MicroLean.MutLinearType.noConfusionType.{u} P t t')
def MicroLean.MutLinearType.noConfusion : forall {P : Sort.{u}} {t : MicroLean.MutLinearType} {t' : MicroLean.MutLinearType}, (Eq.{1} MicroLean.MutLinearType t t') -> (MicroLean.MutLinearType.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : MicroLean.MutLinearType} {t' : MicroLean.MutLinearType} (eq : Eq.{1} MicroLean.MutLinearType t t') => Eq.ndrec.{u, 1} MicroLean.MutLinearType t (fun {t' : MicroLean.MutLinearType} => MicroLean.MutLinearType.noConfusionType.{u} P t t') (MicroLean.MutLinearType.casesOn.{u} (fun {t : MicroLean.MutLinearType} => MicroLean.MutLinearType.noConfusionType.{u} P t t) t (fun (mode : MicroLean.MutMode) (type : MicroLean.MicroLeanType) (k : (Eq.{1} MicroLean.MutMode mode mode) -> (Eq.{1} MicroLean.MicroLeanType type type) -> P) => k (Eq.refl.{1} MicroLean.MutMode mode) (Eq.refl.{1} MicroLean.MicroLeanType type))) t' eq
