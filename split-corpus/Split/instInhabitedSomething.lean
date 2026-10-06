import Mathlib

set_option pp.all true
-- spec: instInhabitedSomething : Inhabited.{1} Something
def instInhabitedSomething : Inhabited.{1} Something :=
  Inhabited.mk.{1} Something Something.Inhabited
