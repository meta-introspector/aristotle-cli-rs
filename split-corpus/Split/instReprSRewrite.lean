import Mathlib

set_option pp.all true
-- spec: instReprSRewrite : Repr.{0} SRewrite
def instReprSRewrite : Repr.{0} SRewrite :=
  Repr.mk.{0} SRewrite instReprSRewrite.repr
