import Mathlib

set_option pp.all true
-- spec: Lean.Name.noConfusion : forall {P : Sort.{u}} {t : Lean.Name} {t' : Lean.Name}, (Eq.{1} Lean.Name t t') -> (Lean.Name.noConfusionType.{u} P t t')
def Lean.Name.noConfusion : forall {P : Sort.{u}} {t : Lean.Name} {t' : Lean.Name}, (Eq.{1} Lean.Name t t') -> (Lean.Name.noConfusionType.{u} P t t') :=
  fun {P : Sort.{u}} {t : Lean.Name} {t' : Lean.Name} (eq : Eq.{1} Lean.Name t t') => Eq.ndrec.{u, 1} Lean.Name t (fun {t' : Lean.Name} => Lean.Name.noConfusionType.{u} P t t') (Lean.Name.casesOn.{u} (fun {t : Lean.Name} => Lean.Name.noConfusionType.{u} P t t) t (fun (k : P) => k) (fun (pre : Lean.Name) (str : String) (k : (Eq.{1} Lean.Name pre pre) -> (Eq.{1} String str str) -> P) => k (Eq.refl.{1} Lean.Name pre) (Eq.refl.{1} String str)) (fun (pre : Lean.Name) (i : Nat) (k : (Eq.{1} Lean.Name pre pre) -> (Eq.{1} Nat i i) -> P) => k (Eq.refl.{1} Lean.Name pre) (Eq.refl.{1} Nat i))) t' eq
