import Mathlib

set_option pp.all true
-- spec: instInhabitedSRewrite : Inhabited.{1} SRewrite
def instInhabitedSRewrite : Inhabited.{1} SRewrite :=
  Inhabited.mk.{1} SRewrite (SRewrite.mk (Inhabited.default.{1} Something instInhabitedSomething) (Inhabited.default.{1} Something instInhabitedSomething) (Option.none.{0} Something) (Inhabited.default.{1} Something instInhabitedSomething))
