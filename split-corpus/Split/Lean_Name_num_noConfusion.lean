import Mathlib

set_option pp.all true
-- spec: Lean.Name.num.noConfusion : forall {P : Sort.{u}} {pre : Lean.Name} {i : Nat} {pre' : Lean.Name} {i' : Nat}, (Eq.{1} Lean.Name (Lean.Name.num pre i) (Lean.Name.num pre' i')) -> ((Eq.{1} Lean.Name pre pre') -> (Eq.{1} Nat i i') -> P) -> P
def Lean.Name.num.noConfusion : forall {P : Sort.{u}} {pre : Lean.Name} {i : Nat} {pre' : Lean.Name} {i' : Nat}, (Eq.{1} Lean.Name (Lean.Name.num pre i) (Lean.Name.num pre' i')) -> ((Eq.{1} Lean.Name pre pre') -> (Eq.{1} Nat i i') -> P) -> P :=
  fun {P : Sort.{u}} {pre : Lean.Name} {i : Nat} {pre' : Lean.Name} {i' : Nat} (eq : Eq.{1} Lean.Name (Lean.Name.num pre i) (Lean.Name.num pre' i')) (k : (Eq.{1} Lean.Name pre pre') -> (Eq.{1} Nat i i') -> P) => id.{u} P (Lean.Name.noConfusion.{u} P (Lean.Name.num pre i) (Lean.Name.num pre' i') eq k)
