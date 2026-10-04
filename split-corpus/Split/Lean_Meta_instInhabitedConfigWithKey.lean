import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instInhabitedConfigWithKey : Inhabited.{1} Lean.Meta.ConfigWithKey
def Lean.Meta.instInhabitedConfigWithKey : Inhabited.{1} Lean.Meta.ConfigWithKey :=
  Inhabited.mk.{1} Lean.Meta.ConfigWithKey Lean.Meta.instInhabitedConfigWithKey._private_1
