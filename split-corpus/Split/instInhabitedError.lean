import Mathlib

set_option pp.all true
-- spec: instInhabitedError : Inhabited.{1} IO.Error
def instInhabitedError : Inhabited.{1} IO.Error :=
  Inhabited.mk.{1} IO.Error (IO.Error.userError "(`Inhabited.default` for `IO.Error`)")
