import Mathlib

set_option pp.all true
-- spec: ByteArray.instAppend : Append.{0} ByteArray
def ByteArray.instAppend : Append.{0} ByteArray :=
  Append.mk.{0} ByteArray ByteArray.append
