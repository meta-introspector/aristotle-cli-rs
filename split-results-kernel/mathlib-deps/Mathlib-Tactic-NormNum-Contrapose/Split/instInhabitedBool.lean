import Mathlib

set_option pp.all true
-- spec: instInhabitedBool : Inhabited.{1} Bool
def instInhabitedBool : Inhabited.{1} Bool :=
  Inhabited.mk.{1} Bool instInhabitedBool.default
