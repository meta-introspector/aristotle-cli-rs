import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedBinderInfo : Inhabited.{1} Lean.BinderInfo
def Lean.instInhabitedBinderInfo : Inhabited.{1} Lean.BinderInfo :=
  Inhabited.mk.{1} Lean.BinderInfo Lean.instInhabitedBinderInfo.default
