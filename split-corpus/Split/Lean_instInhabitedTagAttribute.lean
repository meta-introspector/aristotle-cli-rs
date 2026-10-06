import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedTagAttribute : Inhabited.{1} Lean.TagAttribute
def Lean.instInhabitedTagAttribute : Inhabited.{1} Lean.TagAttribute :=
  Inhabited.mk.{1} Lean.TagAttribute Lean.instInhabitedTagAttribute.default
