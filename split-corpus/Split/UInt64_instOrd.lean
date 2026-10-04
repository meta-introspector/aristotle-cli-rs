import Mathlib

set_option pp.all true
-- spec: UInt64.instOrd : Ord.{0} UInt64
def UInt64.instOrd : Ord.{0} UInt64 :=
  Ord.mk.{0} UInt64 (fun (x : UInt64) (y : UInt64) => compareOfLessAndEq.{0} UInt64 x y instLTUInt64 (UInt64.decLt x y) instDecidableEqUInt64)
