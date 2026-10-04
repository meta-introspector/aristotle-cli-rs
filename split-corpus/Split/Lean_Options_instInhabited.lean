import Mathlib

set_option pp.all true
-- spec: Lean.Options.instInhabited : Inhabited.{1} Lean.Options
def Lean.Options.instInhabited : Inhabited.{1} Lean.Options :=
  Inhabited.mk.{1} Lean.Options Lean.Options.empty
