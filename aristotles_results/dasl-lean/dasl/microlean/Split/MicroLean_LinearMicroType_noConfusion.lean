import Mathlib

set_option pp.all true
-- spec: MicroLean.LinearMicroType.noConfusion : forall {P : Sort.{u}} {t : MicroLean.LinearMicroType} {t' : MicroLean.LinearMicroType}, (Eq.{1} MicroLean.LinearMicroType t t') -> (MicroLean.LinearMicroType.noConfusionType.{u} P t t')
def MicroLean.LinearMicroType.noConfusion : forall {P : Sort.{u}} {t : MicroLean.LinearMicroType} {t' : MicroLean.LinearMicroType}, (Eq.{1} MicroLean.LinearMicroType t t') -> (MicroLean.LinearMicroType.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : MicroLean.LinearMicroType} {t' : MicroLean.LinearMicroType} (eq : Eq.{1} MicroLean.LinearMicroType t t') => Eq.ndrec.{u, 1} MicroLean.LinearMicroType t (fun {t' : MicroLean.LinearMicroType} => MicroLean.LinearMicroType.noConfusionType.{u} P t t') (MicroLean.LinearMicroType.casesOn.{u} (fun {t : MicroLean.LinearMicroType} => MicroLean.LinearMicroType.noConfusionType.{u} P t t) t (fun (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType) (k : (Eq.{1} MicroLean.OwnershipMode mode mode) -> (Eq.{1} MicroLean.MicroLeanType type type) -> P) => k (Eq.refl.{1} MicroLean.OwnershipMode mode) (Eq.refl.{1} MicroLean.MicroLeanType type))) t' eq
