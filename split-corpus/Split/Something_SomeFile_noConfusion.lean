import Mathlib

set_option pp.all true
-- spec: Something.SomeFile.noConfusion : forall {P : Sort.{u}} {content : String} {content' : String}, (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content')) -> ((Eq.{1} String content content') -> P) -> P
def Something.SomeFile.noConfusion : forall {P : Sort.{u}} {content : String} {content' : String}, (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content')) -> ((Eq.{1} String content content') -> P) -> P :=
  fun {P : Sort.{u}} {content : String} {content' : String} (eq : Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content')) (k : (Eq.{1} String content content') -> P) => id.{u} P (Something.noConfusion.{u} P (Something.SomeFile content) (Something.SomeFile content') eq k)
