import Mathlib

set_option pp.all true
-- spec: Something.SomeResource.noConfusion : forall {P : Sort.{u}} {res : String} {res' : String}, (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res')) -> ((Eq.{1} String res res') -> P) -> P
def Something.SomeResource.noConfusion : forall {P : Sort.{u}} {res : String} {res' : String}, (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res')) -> ((Eq.{1} String res res') -> P) -> P :=
  fun {P : Sort.{u}} {res : String} {res' : String} (eq : Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res')) (k : (Eq.{1} String res res') -> P) => id.{u} P (Something.noConfusion.{u} P (Something.SomeResource res) (Something.SomeResource res') eq k)
