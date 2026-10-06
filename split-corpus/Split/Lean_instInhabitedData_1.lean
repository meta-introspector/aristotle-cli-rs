import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedData_1 : Inhabited.{1} Lean.Expr.Data
def Lean.instInhabitedData_1 : Inhabited.{1} Lean.Expr.Data :=
  Inhabited.mk.{1} Lean.Expr.Data Lean.instInhabitedData_1._aux_1
