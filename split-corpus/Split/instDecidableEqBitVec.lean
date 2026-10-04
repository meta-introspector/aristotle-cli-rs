import Mathlib

set_option pp.all true
-- spec: instDecidableEqBitVec : forall {w : Nat}, DecidableEq.{1} (BitVec w)
def instDecidableEqBitVec : forall {w : Nat}, DecidableEq.{1} (BitVec w) :=
  fun {w : Nat} => BitVec.decEq w
