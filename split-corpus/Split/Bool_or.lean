import Mathlib

set_option pp.all true
-- spec: Bool.or : Bool -> Bool -> Bool
def Bool.or : Bool -> Bool -> Bool :=
  fun (x : Bool) (y : Bool) => cond.match_1.{1} (fun (x._@.Init.Prelude.492990823._hygCtx._hyg.8 : Bool) => Bool) x (fun (_ : Unit) => Bool.true) (fun (_ : Unit) => y)
