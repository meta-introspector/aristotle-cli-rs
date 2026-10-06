import Mathlib

set_option pp.all true
-- spec: Lean.Name.str.noConfusion : forall {P : Sort.{u}} {pre : Lean.Name} {str : String} {pre' : Lean.Name} {str' : String}, (Eq.{1} Lean.Name (Lean.Name.str pre str) (Lean.Name.str pre' str')) -> ((Eq.{1} Lean.Name pre pre') -> (Eq.{1} String str str') -> P) -> P
def Lean.Name.str.noConfusion : forall {P : Sort.{u}} {pre : Lean.Name} {str : String} {pre' : Lean.Name} {str' : String}, (Eq.{1} Lean.Name (Lean.Name.str pre str) (Lean.Name.str pre' str')) -> ((Eq.{1} Lean.Name pre pre') -> (Eq.{1} String str str') -> P) -> P :=
  fun {P : Sort.{u}} {pre : Lean.Name} {str : String} {pre' : Lean.Name} {str' : String} (eq : Eq.{1} Lean.Name (Lean.Name.str pre str) (Lean.Name.str pre' str')) (k : (Eq.{1} Lean.Name pre pre') -> (Eq.{1} String str str') -> P) => id.{u} P (Lean.Name.noConfusion.{u} P (Lean.Name.str pre str) (Lean.Name.str pre' str') eq k)
