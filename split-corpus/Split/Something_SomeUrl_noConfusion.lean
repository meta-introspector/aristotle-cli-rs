import Mathlib

set_option pp.all true
-- spec: Something.SomeUrl.noConfusion : forall {P : Sort.{u}} {url : String} {url' : String}, (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url')) -> ((Eq.{1} String url url') -> P) -> P
def Something.SomeUrl.noConfusion : forall {P : Sort.{u}} {url : String} {url' : String}, (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url')) -> ((Eq.{1} String url url') -> P) -> P :=
  fun {P : Sort.{u}} {url : String} {url' : String} (eq : Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url')) (k : (Eq.{1} String url url') -> P) => id.{u} P (Something.noConfusion.{u} P (Something.SomeUrl url) (Something.SomeUrl url') eq k)
