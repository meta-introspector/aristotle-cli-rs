import Mathlib

set_option pp.all true
-- spec: instInhabitedPUnit : Inhabited.{u_1} PUnit.{u_1}
def instInhabitedPUnit : Inhabited.{u_1} PUnit.{u_1} :=
  Inhabited.mk.{u_1} PUnit.{u_1} PUnit.unit.{u_1}
