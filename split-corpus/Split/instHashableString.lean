import Mathlib

set_option pp.all true
-- spec: instHashableString : Hashable.{1} String
def instHashableString : Hashable.{1} String :=
  Hashable.mk.{1} String String.hash
