import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedData : Inhabited.{1} Lean.Level.Data
def Lean.instInhabitedData : Inhabited.{1} Lean.Level.Data :=
  Inhabited.mk.{1} Lean.Level.Data Lean.instInhabitedData._aux_1
